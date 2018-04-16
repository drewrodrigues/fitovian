  # active                boolean           not null, default(false)
  # current_period_end    date              default(yesterday)
  # id                    integer           not null, unique
  # stripe_id             string            not null

class Subscription < ApplicationRecord
  belongs_to :user

  validates_presence_of :current_period_end
  validates_presence_of :stripe_id
  validates_presence_of :user

  def cancel
    return true unless self.active
    stripe_subscription.delete(at_period_end: true)
    self.status = 'canceled'
    self.active = false
    self.save
  end
 
  def stripe_subscription
    return nil unless self.stripe_id
    @stripe_subscription ||= Stripe::Subscription.retrieve(
      self.stripe_id
    )
  end

  def subscribe
    if stripe_subscription
      return true if stripe_subscription.status == 'active'
      delete_stripe_subscription if stripe_subscription.status != 'active'
    end
    @stripe_subscription = Stripe::Subscription.create(
      customer: self.user.stripe_id,
      items: [{ plan: self.user.plan.name }]
    )
    self.active = true
    self.current_period_end = Time.zone.at(@stripe_subscription.current_period_end)
    self.stripe_id = @stripe_subscription.id
    self.status = 'subscribed'
    self.save
  end

  def re_activate
    return false if past_period_end?
    return true if self.active
    stripe_subscription.items = [{
      id: stripe_subscription.items.data[0].id,
      plan: self.user.plan.stripe_id
    }]
    stripe_subscription.save
    self.active = true
    self.save
  end

  def update_end_date(event)
    # webhook object
    self.current_period_end = Time.zone.at(event.data.object.period_end)
    self.save
  end

  private

  def delete_stripe_subscription
    raise 'Cannot delete active subscription' if stripe_subscription.status == 'active'
    Stripe::SubscriptionItem.retrieve(self.stripe_id).delete
  end

  def past_period_end? 
    return true unless self.current_period_end
    self.current_period_end < Date.today
  end
end