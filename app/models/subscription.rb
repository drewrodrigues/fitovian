  # active                boolean           not null, default(false)
  # current_period_end    date              default(yesterday)
  # id                    integer           not null, unique
  # stripe_id             string            not null

class Subscription < ApplicationRecord
  belongs_to :user

  validates_presence_of :current_period_end
  validates_presence_of :stripe_id
  validates_presence_of :user
  validate :set_default_current_period_end, on: :create

  def cancel
    return true unless self.active
    stripe_subscription.delete(at_period_end: true)
    self.active = false
    self.save
  end

  def update_end_date(event)
    # webhook object
    self.current_period_end = Time.zone.at(event.data.object.period_end)
    self.save
  end

  def re_activate
    return true if self.active
    stripe_subscription.items = [{
      id: stripe_subscription.items.data[0].id,
      plan: stripe_plan.id
    }]
    stripe_subscription.save
    self.active = true
    self.save
  end
 
  private

  def set_default_current_period_end
    self.current_period_end = Time.zone.today - 1
  end

  def stripe_subscription
    @stripe_subscription ||= Stripe::Subscription.retrieve(
      self.stripe_id
    )
  end
end