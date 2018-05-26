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

  before_create :give_courses

  after_initialize :set_defaults, :set_trial_period

  validate :set_stripe_id, on: :create
  validates :plan, inclusion: {
    in: %w[starter test], message: 'is not a valid plan'
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
    # TODO: implement this better to not allow N+1 queries
    self.selections.find_by(course: resource)
  end

  private

  def set_trial_period
    self.period_end ||= 3.days.from_now
  end

  def set_defaults
    self.plan ||= Plan.starter_plan
    self.active ||= false
  end

  def give_courses
    self.courses = Course.all
  end
end
