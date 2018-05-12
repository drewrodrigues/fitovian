class SubscriptionHandler
  def initialize(user)
    @user = user
    @stripe = StripeHandler.new(user)
  end

  def subscribe
    return false unless @user.payment_method? && @user.stripe_id

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
    set_inactive!
  end

  private

  def update_period_end
    @user.period_end = Time.zone.at(@stripe.subscription.current_period_end)
    @user.save
  end

  def create_subscription
    Stripe::Subscription.create(
      customer: @user.stripe_id,
      items: [{ plan: @user.plan }]
    )
    set_active!
    update_period_end
  end

  def re_activate
    @stripe.subscription.items = [{
      id: @stripe.subscription.items.data[0].id,
      plan: @user.plan
    }]
    set_active!
    update_period_end
    @stripe.subscription.save
  end

  def canceled?
    @stripe.subscription.cancel_at_period_end
  end

  def set_active!
    @user.active = true
    @user.save!
  end

  def set_inactive!
    @user.active = false
    @user.save!
  end
end
