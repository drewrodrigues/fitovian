require 'test_helper'
require 'helpers/billing_controller_test_helper'

class BillingControllerTest < ActionDispatch::IntegrationTest
  # TODO: make help methods to reduce code
  include Devise::Test::IntegrationHelpers
  include BillingControllerTestHelper

  test "as guest, dashboard should re-direct to login page" do
    get billing_dashboard_path
    assert_redirected_to new_user_session_path
  end

  test "as user, should get dashboard" do
    sign_in(users(:user))

    get billing_dashboard_path
    assert_response :success
  end

  test "as guest, re-direct to login page" do
    get new_payment_method_path
    assert_redirected_to new_user_session_path
  end

  test "as user, should get update" do
    user = User.create(email: 'test@eaxmple.com', name: 'foobar', password: 'foobar')
    sign_in(user)

    get new_payment_method_path
    assert_response :success
  end

  test "should redirect to root_path upon successful subscribe" do
    run_stripe_mock do
      user = User.create(email: 'test@eaxmple.com', name: 'foobar', password: 'foobar')
      sign_in(user)

      post subscribe_path(StripeMock.create_test_helper.generate_card_token)

      assert_redirected_to root_path
      assert_equal 'Successfully subscribed', flash[:success]
    end
  end

  test "should re-render billing page upon failed subscription from card decline" do
    run_stripe_mock do
      StripeMock.prepare_card_error(:card_declined, :create_subscription)

      user = User.create(email: 'test@eaxmple.com', name: 'foobar', password: 'foobar')
      sign_in(user)

      post subscribe_path(StripeMock.create_test_helper.generate_card_token)

      assert_template 'new'
      assert_equal 'The card was declined', flash[:alert]
    end
  end

  test "should re-render billing page upon failed subscription from duplicate subscription" do
    run_stripe_mock do
      user = User.create(email: 'test@eaxmple.com', name: 'foobar', password: 'foobar')
      sign_in(user)

      post subscribe_path(StripeMock.create_test_helper.generate_card_token)
      assert_redirected_to root_path

      post subscribe_path(StripeMock.create_test_helper.generate_card_token)
      assert_template 'new'
      assert_equal 'Already subscribed', flash[:alert]
    end
  end

  test "should re-render billing page upon successful cancel" do
    run_stripe_mock do
      user = User.create(email: 'teste@example.com', name: 'foobar', password: 'foobar')
      sign_in(user)

      post subscribe_path(StripeMock.create_test_helper.generate_card_token)
      assert_redirected_to root_path

      get root_path

      delete cancel_subscription_path

      assert_template 'new'
      assert_equal 'Successfully canceled subscription', flash[:success]
    end
  end

  test "should re-render billing page upon failed cancel (from not subscribed user)" do
    run_stripe_mock do
      user = User.create(email: 'teste@example.com', name: 'foobar', password: 'foobar')
      sign_in(user)

      get billing_dashboard_path
      delete cancel_subscription_path

      assert_template 'new'
      assert_equal 'Subscription doesn\'t exist', flash[:alert]
    end
  end

  test "should render billing page upon successful re_activate" do
    run_stripe_mock do
      user = User.create(email: 'teste@example.com', name: 'foobar', password: 'foobar')
      sign_in(user)

      get billing_dashboard_path
      post subscribe_path(StripeMock.create_test_helper.generate_card_token)
      assert_redirected_to root_path

      delete cancel_subscription_path
      assert_template 'new'

      put re_activate_path
      assert_template 'new'
      assert_equal 'Successfully re-activated subscription', flash[:success]
    end
  end

  test "should render billing page upon re_active attempt when already active" do
    run_stripe_mock do
      user = User.create(email: 'teste@example.com', name: 'foobar', password: 'foobar')
      sign_in(user)

      get billing_dashboard_path
      post subscribe_path(StripeMock.create_test_helper.generate_card_token)
      assert_redirected_to root_path

      put re_activate_path
      assert_template 'new'
      assert_equal 'Subscription already active', flash[:alert]
    end
  end

  test "should render billing page upon successful add payment method" do
    run_stripe_mock do
      user = User.create(email: 'teste@example.com', name: 'foobar', password: 'foobar')
      sign_in(user)

      get billing_dashboard_path
      post subscribe_path(StripeMock.create_test_helper.generate_card_token)
      assert_redirected_to root_path

      get new_payment_method_path
      assert_response :success
      put update_payment_method_path(StripeMock.create_test_helper.generate_card_token)

      assert_redirected_to billing_dashboard_path
      assert_equal 'Successfully updated payment method', flash[:success]
    end
  end

  test "should render update page upon failed add payment method" do
    run_stripe_mock do
      user = User.create(email: 'teste@example.com', name: 'foobar', password: 'foobar')
      sign_in(user)

      get billing_dashboard_path
      post subscribe_path(StripeMock.create_test_helper.generate_card_token)
      assert_redirected_to root_path

      StripeMock.prepare_card_error(:incorrect_number, :create_source)
      get new_payment_method_path
      assert_response :success
      put update_payment_method_path(StripeMock.create_test_helper.generate_card_token)

      assert_template 'update'
      assert_equal 'The card number is incorrect', flash[:alert]
    end
  end
end
