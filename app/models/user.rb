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
    self.period_end >= Time.zone.today
  end

  def admin?
    self.admin
  end

  def default_card
    self.cards.where(default: true).first
  end

  def payment_method?
    self.cards.count.positive?
  end

  def plan?
    self.plan
  end

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
