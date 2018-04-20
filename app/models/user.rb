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

  # USER ############################################################

  def admin?
    admin
  end

  def set_stripe_id
    self.stripe_id = Stripe::Customer.create(
      email: self.email
    ).id
  rescue Stripe::StripeError
    errors.add(:stripe_id, 'cannot be set')
  end

  private :set_stripe_id

  # CARDS ###########################################################

  def payment_method?
    cards.count > 0
  end

  # add a card and set to default
  def add_card(token)
    card = Card.add(self, token)
    default_card(card)
  end

  # set the card to default
  # or retrieve the default card
  def default_card(card = nil)
    if card
      stripe_card_default(card)
      remove_previous_default
      card.default = true
      card.save
    else
      self.cards.find_by_default(true)
    end
  end

  # delete the card from stripe and the db
  # don't allow if it's the default card
  def delete_card(card)
    return false if card.default
    self.stripe_customer.sources.retrieve(card.stripe_id).delete
    card.destroy
  end

  # if there's a default card
  # set it to default = false
  def remove_previous_default
    previous_default = self.cards.where(default: true).first 
    return true unless previous_default
    previous_default.default = false
    previous_default.save
  end

  # set the passed card to stripe's default card
  def stripe_card_default(card)
    stripe_customer.default_source = card.stripe_id
    stripe_customer.save
  end

  private :remove_previous_default, :stripe_card_default

  # SUBSCRIPTIONS ###################################################

  def subscribe
    # FIXME: how can we simplify this line? Make a call to subscribe only
    self.subscription ? self.subscription.subscribe : Subscription.subscribe(self)
  end

  def cancel
    return false unless self.subscription
    self.subscription.cancel
  end

  def active?
    return false unless self.subscription
  end

  # PLANS ###########################################################

  def select_starter_plan
    # TODO: ensure if user is subscribed, it changed the plan
    self.plan = Plan.starter_plan
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

  def plan?
    plan
  end
end
