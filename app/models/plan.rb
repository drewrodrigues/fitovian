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

  private

  def defined_plan?
    return true if self.name == STARTER[:name] && self.stripe_id == STARTER[:stripe_id] && self.price == STARTER[:price]
    return true if self.name == PREMIUM[:name] && self.stripe_id == PREMIUM[:stripe_id] && self.price == PREMIUM[:price]
    errors.add(:plan, 'is invalid.')
  end
end
