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
  has_many :courses, through: :selections

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # after_initialize :set_defaults

  validate :set_stripe_id, on: :create
  validates :plan, inclusion: { 
    in: ['starter', 'test', message: 'is not a valid plan']
  }

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

  def selected?(resource)
    self.courses.find_by(id: resource)
  end

  private

  def set_defaults
    self.period_end ||= 3.days.from_now
    self.plan ||= Plan.starter_plan
    self.active ||= false
    self.courses ||= Course.all
  end
end
