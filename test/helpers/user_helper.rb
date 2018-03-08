module UserHelper
  def create_stripe_user(user)
    # TODO: find a better solution for testing stripe_user
    # because if I set the fixture's stripe_customer_id to a generated id, then
    # once the test starts, StripeMock doesn't recognize it because it hasn't
    # generated it yet... But then if I don't put anything in, I can't test for
    # validity.
    if user.stripe_customer_id == 'delete'
      user.stripe_customer_id = Stripe::Customer.create.id
    end
    user.stripe_customer_id ||= Stripe::Customer.create.id
  end

  def subscribe(user, token = nil)
    create_stripe_user(user)
    add_payment_method(user, token)
    user.subscribe
  end

  def add_payment_method(user, token = nil)
    create_stripe_user(user)
    token ||= StripeMock.create_test_helper.generate_card_token
    user.add_payment_method(token)
  end
end
