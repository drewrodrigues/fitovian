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

  validates :user, presence: true
  validate :defined_plan?

  def self.starter_plan
    plan = Plan.new
    plan.stripe_id = STARTER[:stripe_id]
    plan.name = STARTER[:name]
    plan.price = STARTER[:price]
    plan
  end

  def defined_plan?
    return true if self.name == STARTER[:name] && self.stripe_id == STARTER[:stripe_id] && self.price == STARTER[:price]
    errors.add(:plan, 'is invalid.')
  end

  private :defined_plan?
end
