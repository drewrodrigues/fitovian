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
    self.admin
  end

  def active?
    return false unless self.subscription
  end

  def has_plan?
    self.plan
  end

  def has_payment_method?
    !self.cards.empty?
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(self.stripe_id)
  rescue Stripe::StripeError
    false
  end

  def default_payment_method
    self.cards.where(default: true).first
  end

  def has_payment_method?
    self.cards.count > 0
  end

  private

  def set_stripe_id
    self.stripe_id ||= Stripe::Customer.create.id
  rescue Stripe::StripeError
    errors.add(:stripe_id, "cannot be set")
  end
end
