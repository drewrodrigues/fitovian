require 'test_helper'
require 'stripe_mock'
require 'helpers/user_helper'

class UserTest < ActiveSupport::TestCase
  include UserHelper

  setup do
    StripeMock.start
    StripeMock.create_test_helper.create_plan(id: 'basic', amount: 1999, interval: 'month')
  end

  teardown do
    StripeMock.stop
  end

  # - Validations & Defaults ###################################################

  test "should be a valid user" do
    users = [users(:user), users(:admin)]

    users.each do |user|
      user.update_attribute(:stripe_customer_id, 'anythignfornow')
      assert user.valid?
      user.update_attribute(:stripe_customer_id, 'changefornow')
    end
  end

  test "should validate presence of name" do
    user = users(:user)

    assert user.name
    assert user.valid?

    user.name = nil
    assert user.invalid?
    assert_not user.save
  end

  test "should validate presence of email" do
    user = users(:user)

    assert user.email
    assert user.valid?

    user.email = nil
    assert user.invalid?
    assert_not user.save
  end

  test "should validate uniqueness of stripe_user_id" do
    user = users(:user)
    user2 = user.dup
    user2.email = 'somethingelse@gmail.com'
    user2.password = 'something'

    assert user2.invalid?
    assert user2.errors.full_messages.include?("Stripe customer has already been taken")
  end

  test "upon new user, stripe_customer_id is assigned" do
    user = User.new(name: 'someone', email: 'something@masdoi.com', password: 'password')
    assert user.stripe_customer_id

    user.save
    assert user.stripe_customer_id
  end

  test "should set active to false by default" do
    user = User.new(name: 'someone', email: 'someone@test.com', password: 'password')

    assert_equal user.active, false
    user.save
    assert_equal user.active, false
  end

  test "should set admin to false by default on create" do
    user = User.new(name: 'someone', email: 'someone@test.com', password: 'password')
    user.save

    assert_not user.is_admin?
  end

  # - Questions ################################################################

  test "membership_active? should return true if current_period_end is in future" do
    Timecop.travel(Date.current)
    user = users(:user)
    user.current_period_end = Date.current + 1
    assert user.membership_active?
  end

  test "membership_active? should return false if current_period_end is in past" do
    Timecop.travel(Date.current)
    user = users(:user)
    user.current_period_end = Date.current - 1
    assert_not user.membership_active?
  end

  test "membership_active? should return true if current_period_end is today" do
    Timecop.travel(Date.current)
    user = users(:user)
    user.current_period_end = Date.current
    assert user.membership_active?
  end

  test "is_admin? should return admin property" do
    user = users(:user)

    assert_equal user.is_admin?, user.admin
  end

  # - Actions ##################################################################

  test "#set_active should throw an error if membership is inactive" do
    user = users(:user)
    user.current_period_end = Date.today - 1000

    assert_raise StandardError do
      user.set_active
    end
  end

  test "#set_end_date sets current_period_end to event period_end with webhook event" do
    Timecop.travel(Date.new(2018, 1, 1))
    user = users(:user)
    event = StripeMock.mock_webhook_event('invoice.payment_succeeded', {
      id: user.stripe_customer_id,
      period_end: 1_517_443_200
    })
    user.set_end_date event
    assert_in_delta 1.month.from_now, user.current_period_end, 200
  end

  test "#set_end_date sets current_period_end to event current_period_end with subscription" do
    user = users(:user)
    subscribe(user)
    assert_in_delta 1.month.from_now, user.current_period_end, 200
  end

  test "#subscribe should set membership to active" do
    today = Date.new(2018, 1, 1)
    membership_end = Date.new(2018, 2, 1)
    Timecop.travel(today)
    user = users(:user)
    subscribe(user)
    assert user.membership_active?
  end

  test "#subscribe should not change anything upon failure" do
    user = users(:user)
    assert_not user.membership_active?
    assert_not user.active

    assert_raise do
      StripeMock.prepare_card_error(:card_declined, :create_subscription)
      subscribe(user)
    end

    assert_not user.membership_active?
    assert_not user.active
  end

  test "won't allow duplicate subscription" do
    user = users(:user)
    subscribe(user)

    assert_raise do
      user.subscribe
    end
  end

  test "#subcribe should re-activate the subscription if within current_end_period" do
    user = users(:user)
    subscribe(user)

    assert user.active
    assert user.membership_active?

    user.cancel
    assert_not user.active
    assert user.membership_active?

    user.re_activate
    assert user.active
    assert user.membership_active?
  end

  test "#subscribe should attempt to subscribe if unable to re-activate" do
    # this is where the question of, does the subscription object still exist
    # on the Stripe::Customer after the subscription has lapsed (passed the end date)?
    # if so, then we have to re-make the subscription object and apply it to the user,
    # otherwise, we can just re-activate
  end

  test "#cancel should set active to false" do
    user = users(:user)
    subscribe(user)

    assert user.active
    user.cancel
    assert_not user.active
  end

  test "membership should still be active if within current_end_date after #cancel" do
    user = users(:user)
    subscribe(user)

    assert user.membership_active?
    user.cancel
    assert user.membership_active?
  end

  test "should add a new payment method and set to default" do
    user = users(:user)
    assert_nil user.default_payment_method

    add_payment_method(user)

    assert_equal user.payment_methods.length, 1
    assert_not_nil user.default_payment_method
  end

  test "new payment method overrides old payment method" do
    user = users(:user)
    old_token = StripeMock.create_test_helper.generate_card_token
    new_token = StripeMock.create_test_helper.generate_card_token

    subscribe(user, old_token)
    new_payment_method = user.add_payment_method(new_token)

    assert_equal user.payment_methods.length, 2
    assert_equal user.default_payment_method, new_payment_method
  end
end
