# == Schema Information
# Table name: users
#
#  id                     :integer          not null, primary key
#  admin                  :boolean          default(false)
#  email                  :string           not null
#  name                   :string           not null
#  stripe_id              :string

# A User is the access point to the application. Guests can only access a small
# part of the application, while Users and Users who are admins are allowed
# to do much more. A User can have cards, a plan and a subscription. It's the
# User class' responsiblity to watch over its resources and handle them
# accordingly.
class User < ApplicationRecord
  belongs_to :track, optional: true

  has_many :completions, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_one :plan, dependent: :destroy
  has_many :selections, dependent: :destroy
  has_many :stacks, through: :selections
  has_one :subscription, dependent: :destroy

  validates :name, presence: true
  validate :set_stripe_id, on: :create

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Returns true if User's is active. Meaning the User's Subscription
  # end date is either today or farther away. So the user should have access.
  def active?
    # TODO: implement with time, to give access
    return false unless self.subscription
  end

  def admin?
    self.admin
  end

  def payment_method?
    self.cards.count.positive?
  end

  def plan?
    self.plan
  end

  # Sets the User's stripe_id
  def set_stripe_id
    self.stripe_id = Stripe::Customer.create(
      email: self.email
    ).id
  rescue Stripe::StripeError
    errors.add(:stripe_id, 'cannot be set')
  end

  private :set_stripe_id

  # add a card to user and sets it to default
  # @param token [String] the Stripe card token generated from the view
  # @return [Boolean] whether the card was saved as the default or not
  def add_card(token)
    card = Card.add(self, token)
    default_card(card)
  end

  # @overload default_card(card)
  #   Sets the card to default
  #   @param card [Card] the card to set to default
  #   @return [Boolean] whether it was set to default or not
  # @overload default_card()
  #   Gets the user's default card
  #   @return [Card] the user's default card
  def default_card(card = nil)
    if card
      return true if card == self.default_card
      stripe_card_default(card)
      remove_previous_default
      card.default = true
      card.save
    else
      self.cards.find_by(default: true)
    end
  end

  # delete the card from stripe and the db
  # don't allow if it's the default card
  def delete_card(card)
    return false if card.default
    self.stripe_customer.sources.retrieve(card.stripe_id).delete
    card.destroy
  end

  # Set previous default card to non-default
  def remove_previous_default
    previous_default = self.cards.find_by(default: true)
    return true unless previous_default
    previous_default.default = false
    previous_default.save
  end

  # Sets the Stripe::Customer's default card
  # @param card [Card] the card to set to default
  # @return [Boolean] whether it was successful
  def stripe_card_default(card)
    stripe_customer.default_source = card.stripe_id
    stripe_customer.save
  end

  private :remove_previous_default, :stripe_card_default

  # Subscribes the User to it's selected Plan
  def subscribe
    self.subscription&.subscribe || Subscription.subscribe(self)
  end

  # Cancels the User's Subscription
  def cancel
    return false unless self.subscription
    self.subscription.cancel
  end

  # Selects the starter plan for the User
  def select_starter_plan
    # TODO: ensure if user is subscribed, it changed the plan
    self.plan = Plan.starter_plan
    self.save
  end

  # Selects the test plan for the User
  def select_test_plan
    self.plan = Plan.test_plan
    self.save
  end

  # Retrieves the Stripe Customer
  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(self.stripe_id)
  rescue Stripe::StripeError
    false
  end

  def complete(resource)
    return true if self.completed?(resource)
    self.completions.build(completable: resource).save
  end

  def incomplete(resource)
    return true unless self.completed?(resource)
    self.completions.find_by(completable: resource)&.destroy
  end

  def completed?(resource)
    self.completions.find_by(completable: resource)
  end

  def selected?(resource)
    self.selections.find_by(stack: resource)
  end
end
