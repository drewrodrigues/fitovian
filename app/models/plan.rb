# == Schema Information
# Table name: plans
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  price                  :float            not null
#  stripe_id              :string           not null
#  user_id                :integer          not null, foreign key

# Plan is the User's selected plan. It represents a Stripe::Plan which is
# created using the Stripe dashboard.
class Plan < ApplicationRecord
  # Stripe::Plan attributes created on Stripe using the Stripe Dashboard
  STARTER = {
    stripe_id: 'starter',
    name: 'starter',
    price: 1999
  }.freeze

  # Stripe::Plan attributes created on Stripe using the Stripe Dashboard
  TEST = {
    stripe_id: 'test',
    name: 'test',
    price: 0
  }.freeze

  belongs_to :user

  validates :user, presence: true
  validate :defined_plan?

  # Builds a Plan from the STARTER plan attributes
  # @return [Plan] the plan with STARTER attributes assigned
  def self.starter_plan
    plan = Plan.new
    plan.stripe_id = STARTER[:stripe_id]
    plan.name = STARTER[:name]
    plan.price = STARTER[:price]
    plan
  end

  # Builds a Plan from the STARTER plan attributes.
  # @return [Plan] the plan with STARTER attributes assigned
  def self.test_plan
    plan = Plan.new
    plan.stripe_id = TEST[:stripe_id]
    plan.name = TEST[:name]
    plan.price = TEST[:price]
    plan
  end

  def defined_plan?
    defined = true
    %i[stripe_id name price].each do |attri|
      unless [TEST[attri], STARTER[attri]].include?(self.send(attri))
        defined = false
        break
      end
    end
    errors.add(:plan, 'is invalid.') unless defined
  end

  private :defined_plan?
end
