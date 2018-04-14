# Table
###############################################################################
# admin                     boolean       default(false)
# email                     string        not null, unique
# id                        integer       not null, unique
# name                      string        not null
# stripe_id                 string        not null, unique

# Associations
###############################################################################
# cards
# plan
# subscription

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name
  validate :set_stripe_id, on: :create

  has_many :cards, dependent: :destroy
  has_one :plan, dependent: :destroy
  has_one :subscription, dependent: :destroy

  def admin?
    admin
  end

  def active?
    return false unless self.subscription
  end

  def plan?
    plan
  end

  def default_card
    cards.where(default: true).first
  end

  def payment_method?
    cards.count > 0
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(self.stripe_id)
  rescue Stripe::StripeError
    false
  end

  def select_starter_plan
    self.plan = Plan.starter_plan
  end

  def select_premium_plan
    self.plan = Plan.premium_plan
  end

  def add_fake_card
    token = StripeMock.create_test_helper.generate_card_token()
    card = stripe_customer.sources.create(source: token)
    self.cards << Card.new(stripe_id: card.id, last4: card.last4, default: true)
  end

  def subscribe
    raise 'Please choose a plan before subscribing' unless self.plan
    raise 'Please add a credit card before subscribing' if self.cards.empty?
    @stripe_subscription = Stripe::Subscription.create(
      customer: self.stripe_id,
      items: [{ plan: self.plan.name }]
    )
    subscription = self.build_subscription(
      active: true,
      current_period_end: Time.zone.at(@stripe_subscription.current_period_end),
      stripe_id: @stripe_subscription.id,
      status: 'subscribed'
    )
    self.subscription = subscription
  end

  def re_activate
    return false unless self.subscription
    self.subscription.re_activate
  end

  def cancel
    return true unless self.subscription
    self.subscription.cancel
  end

  private

  def set_stripe_id
    self.stripe_id = Stripe::Customer.create(
      email: self.email
    ).id
  rescue Stripe::StripeError
    errors.add(:stripe_id, 'cannot be set')
  end
end
