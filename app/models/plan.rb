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
  }.freeze

  ADMIN = {
    stripe_id: 'admin',
    name: 'admin',
    price: 0
  }.freeze

  validates :user, presence: true
  validate :defined_plan?

  def self.starter_plan
    plan = Plan.new
    plan.stripe_id = STARTER[:stripe_id]
    plan.name = STARTER[:name]
    plan.price = STARTER[:price]
    plan
  end

  def self.admin_plan
    plan = Plan.new
    plan.stripe_id = ADMIN[:stripe_id]
    plan.name = ADMIN[:name]
    plan.price = ADMIN[:price]
    plan
  end

  def defined_plan?
    defined = true
    %i[stripe_id name price].each do |attri|
      unless [ADMIN[attri], STARTER[attri]].include?(self.send(attri))
        defined = false
        break
      end
    end
    errors.add(:plan, 'is invalid.') unless defined
  end

  private :defined_plan?
end
