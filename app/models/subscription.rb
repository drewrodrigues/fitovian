  # active                boolean           not null, default(false)
  # current_period_end    date              default(yesterday)
  # id                    integer           not null, unique
  # stripe_id             string            not null

class Subscription < ApplicationRecord
  belongs_to :user

  validates_presence_of :current_period_end
  validates_presence_of :stripe_id
  validates_presence_of :user

  def self.subscribe(user)
    # creates a new subscription for the user,
    # and adds a stripe subscription
    stripe_subscription = create_stripe_subscription(user)
    subscription = user.build_subscription(
      active: true,
      current_period_end: Time.zone.at(stripe_subscription.current_period_end),
      stripe_id: stripe_subscription.id,
      status: 'subscribed'
    )
    subscription.save
  end

  def cancel
    # if the subscription isn't active, then
    # the subscription is already canceled
    return true unless self.active
    stripe_subscription.delete(at_period_end: true)
    cancel!
  end

  def subscribe
    if stripe_subscription
      # then we want to either re_activate it,
      # or delete the old subscription and create a new one
      # so we don't create duplicates
      re_activate || destroy_and_create_stripe_subscription  
    else
      Subscription.subscribe(self.user)
      create_stripe_subscription
    end
  end

  def stripe_subscription
    return nil unless self.stripe_id
    @stripe_subscription ||= Stripe::Subscription.retrieve(
      self.stripe_id
    )
  end

  private

    def self.create_stripe_subscription(user)
      # creates a stripe subscription with the
      # user's selected plan
      Stripe::Subscription.create(
        customer: user.stripe_id,
        items: [{ plan: user.plan.name }]
      )
    end

    def destroy_and_create_stripe_subscription
      delete_stripe_subscription
      Subscription.subscribe(self.user)
    end

    def re_activate
      # make sure we can re-activate it, which means the status
      # is active and cancel_at_period_end is set to false
      # if cancel_at_period end is set to false, then
      # the subscription is already re-activated
      return false if stripe_subscription.status != 'active'
      return true unless stripe_subscription.cancel_at_period_end
      active!
      stripe_subscription.items = [{
        id: stripe_subscription.items.data[0].id,
        plan: self.user.plan.stripe_id
      }]
      stripe_subscription.save
    end

    def update_end_date(event)
      # webhook object
      self.current_period_end = Time.zone.at(event.data.object.period_end)
      self.save
    end

    def delete_stripe_subscription
      raise 'Cannot delete active subscription' if stripe_subscription.status == 'active'
      Stripe::SubscriptionItem.retrieve(self.stripe_id).delete
    end

    def past_period_end? 
      return true unless self.current_period_end
      self.current_period_end < Date.today
    end

    def active!
      self.active = true
      self.status = 'subscribed'
      self.save
    end

    def cancel!
      self.status = 'canceled'
      self.active = false
      self.save
    end
end