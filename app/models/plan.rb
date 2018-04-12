# Table
###############################################################################
# id                integer
# name              string
# price             float
# stripe_id         string

class Plan < ApplicationRecord
  belongs_to :user

  STARTER = {
    stripe_id: 'starter',
    name: 'starter',
    price: 1999
  }

  PREMIUM = {
    stripe_id: 'premium',
    name: 'premium',
    price: 3999
  }

  validates :user, presence: true
  validate :defined_plan?

  def self.starter_plan
    plan = Plan.new
    plan.stripe_id = STARTER[:stripe_id]
    plan.name = STARTER[:name]
    plan.price = STARTER[:price]
    plan
  end

  def self.premium_plan
    plan = Plan.new
    plan.stripe_id = PREMIUM[:stripe_id]
    plan.name = PREMIUM[:name]
    plan.price = PREMIUM[:price]
    plan
  end

  private

  def defined_plan?
    return true if self.name == STARTER[:name] && self.stripe_id == STARTER[:stripe_id] && self.price == STARTER[:price]
    return true if self.name == PREMIUM[:name] && self.stripe_id == PREMIUM[:stripe_id] && self.price == PREMIUM[:price]
    errors.add(:plan, 'is invalid.')
  end
end
