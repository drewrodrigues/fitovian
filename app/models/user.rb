# == Schema Information
# Table name: users
#
#  id                     :integer          not null, primary key
#  admin                  :boolean          default(false)
#  email                  :string           not null
#  name                   :string           not null
#  period_end             :date             not null
#  plan                   :string           not null, default('starter')
#  stripe_id              :string

class User < ApplicationRecord
  belongs_to :track, optional: true

  has_many :completions, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :selections, dependent: :destroy
  has_many :stacks, through: :selections

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :period_end, presence: true
  validate :set_stripe_id, on: :create

  def set_stripe_id
    StripeHandler.set_stripe_id(self)
  end

  def active?
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

  def add_card(token)
    card = Card.add(self, token)
    default_card(card)
  end

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

  def delete_card(card)
    return false if card.default
    self.stripe_customer.sources.retrieve(card.stripe_id).delete
    card.destroy
  end

  def remove_previous_default
    previous_default = self.cards.find_by(default: true)
    return true unless previous_default
    previous_default.default = false
    previous_default.save
  end

  def stripe_card_default(card)
    stripe_customer.default_source = card.stripe_id
    stripe_customer.save
  end

  private :remove_previous_default, :stripe_card_default

  def select_starter_plan
    self.plan = Plan.starter_plan
  end

  def select_test_plan
    self.plan = Plan.test_plan
  end

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
