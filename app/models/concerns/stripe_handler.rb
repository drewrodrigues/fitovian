class StripeHandler
  def initialize(user)
    @user = user
    ensure_stripe_id
  end

  def self.set_stripe_id(user)
    return true if user.stripe_id
    user.stripe_id = Stripe::Customer.create(
      email: user.email
    ).id
  end

  def customer
    @stripe_customer = Stripe::Customer.retrieve(@user.stripe_id)
  end

  def subscription
    raise 'Subscription doesn\'t exist' if subscription_count.zero?
    @stripe_subscription = customer.subscriptions.data.first
  end

  def subscription_count
    customer.subscriptions.total_count
  end

  def default_card
    # TODO: test
    customer.default_source
  end

  def card_count
    customer.sources.total_count
  end

  private

  def ensure_stripe_id
    StripeHandler.set_stripe_id(@user)
    throw 'User doesn\'t doesn\'t have a Stripe ID' unless @user.stripe_id
  end
end
