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
    self.cards.find_by_default(true)
  end

  def payment_method?
    cards.count > 0
  end

  def subscribe
    # FIXME: how can we simplify this line? Make a call to subscribe only
    self.subscription ? self.subscription.subscribe : Subscription.subscribe(self)
  end

  def cancel
    return false unless self.subscription
    self.subscription.cancel
  end

  def select_starter_plan
    # TODO: ensure if user is subscribed, it changed the plan
    self.plan = Plan.starter_plan
    self.save
  end

  def select_premium_plan
    # TODO: ensure if user is subscribed, it changed the plan
    self.plan = Plan.premium_plan
    self.save
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(self.stripe_id)
  rescue Stripe::StripeError
    false
  end

  def add_fake_card
    token = StripeMock.create_test_helper.generate_card_token()
    card = stripe_customer.sources.create(source: token)
    self.cards << Card.new(stripe_id: card.id, last4: card.last4, default: true)
    @card = default_card
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
