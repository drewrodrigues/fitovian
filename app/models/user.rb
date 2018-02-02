class User < ApplicationRecord
  # Schema ############################
  # active_subscription: boolean
  # - default: false
  # admin: boolean
  # - default: false
  # current_period_end: date
  # email: string
  # stripe_customer_id: string
  # stripe_subscription_id: string

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Questions #########################
  def subscription_active?
    self.active_subscription
  end

  def admin?
    self.admin
  end

  def membership_active?
    return false unless current_period_end
    self.current_period_end > Date.current
  end

  # Actions ###########################
  def cancel_subscription
    subscription = Stripe::Subscription.retrieve(self.stripe_subscription_id)
    subscription.delete(at_period_end: true)
    self.active_subscription = false
    self.save
  end

  def subscribe
    subscription = Stripe::Subscription.create({
      customer: self.stripe_customer_id,
      items: [{plan: 'basic'}] # TODO: make this more flexible
    })
    set_subscription_one_month
    self.stripe_subscription_id = subscription.id
    self.active_subscription = true
    self.save
  end

  def re_activate
    subscription = Stripe::Subscription.retrieve(self.stripe_subscription_id)
    subscription.items = [{
        id: subscription.items.data[0].id,
        plan: 'basic',
    }]
    subscription.save
    self.active_subscription = true
    self.save
  end

  def set_stripe_customer_id(stripeToken)
    self.stripe_customer_id = Stripe::Customer.create(
      source: stripeToken
    ).id
  end

  def set_subscription_one_month
    date = Date.current
    next_month = (1..12).include?(date.month) ? date.month + 1 : 1
    one_month_out = Date.new(date.year, next_month, date.day)
    self.current_period_end = one_month_out
    self.save
  end
end
