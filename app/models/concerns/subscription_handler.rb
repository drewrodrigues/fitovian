class SubscriptionHandler
  def initialize(user)
    @user = user
    @stripe = StripeHandler.new(user)
    raise 'Stripe ID not set' unless @user.stripe_id
    raise 'Please add payment method' unless @user.payment_method?
  end

  def subscribe
    if @stripe.subscription_count.zero?
      create_subscription
    elsif canceled?
      re_activate
    else
      true
    end
  end

  def cancel
    return true if @stripe.subscription_count.zero?
    @stripe.subscription.delete(at_period_end: true)
  end

  private

  def update_period_end
    @user.period_end = Time.zone.at(@stripe.subscription.current_period_end)
  end

  def create_subscription
    Stripe::Subscription.create(
      customer: @user.stripe_id,
      items: [{ plan: @user.plan }]
    )
    update_period_end
  end

  def re_activate
    @stripe.subscription.items = [{
      id: @stripe.subscription.items.data[0].id,
      plan: @user.plan
    }]
    @stripe.subscription.save
  end

  def canceled?
    @stripe.subscription.cancel_at_period_end
  end
end
