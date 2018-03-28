  # active                boolean           not null, default(false)
  # current_period_end    date              default(yesterday)
  # id                    integer           not null, unique
  # stripe_id             string            not null
  # subscribed            boolean           not null, default(false)

class Subscription < ApplicationRecord
  belongs_to :user

  validates_presence_of :active
  validates_presence_of :current_period_end
  validates_presence_of :stripe_id
  validates_presence_of :subscribed
  validates_presence_of :user

  validate :set_stripe_id, on: :create
  validate :set_default_current_period_end, on: :create

  def subscribe
    return true if subscribed?
    @stripe_subscription = Stripe::Subscription.create(
      customer: self.stripe_customer_id,
      items: [{ plan: self.plan.id }]
    )
    self.current_period_end = Time.zone.at(@stripe_subscription.current_period_end)
    self.active = true
    self.stripe_subscription_id = @stripe_subscription.id
    self.save
  end

  def cancel
    return true unless self.active
    stripe_subscription.delete(at_period_end: true)
    self.active = false
    self.save
  rescue Stripe::StripeError => e
    false
  end

  def update_end_date(event)
    # webhook object
    self.current_period_end = Time.zone.at(event.data.object.period_end)
    self.save
  end

  def re_activate
    return true if subscribed
    stripe_subscription.items = [{
      id: stripe_subscription.items.data[0].id,
      plan: stripe_plan.id
    }]
    stripe_subscription.save
    self.active = true
    self.subscribed = true
    self.save
  rescue Stripe::StripeError => e
    false
  end
 
  private

  def set_default_current_period_end
    self.current_period_end = Time.zone.today - 1
  end

  def stripe_subscription
    return false unless self.stripe_subscription_id
    @stripe_subscription ||= Stripe::Subscription.retrieve(
      self.stripe_subscription_id
    )
  rescue Stripe::StripeError
    @stripe_subscription ||= nil
  end

  def set_stripe_id
  end
end
