class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  before_create :set_subscription_default

  def admin?
    self.admin
  end

  def set_subscription_one_month
    date = Date.current
    next_month = (1..12).include?(date.month) ? date.month + 1 : 1
    one_month_out = Date.new(date.year, next_month, date.day)
    self.current_period_end = one_month_out
    self.save
  end

  def membership_active?
    return false unless current_period_end
    self.current_period_end > Date.current
  end

  def active_subscription?
    self.active_subscription
  end

  def set_active_membership
    self.active_membership = true
    self.save
  end

  def cancel_subscription
    self.active_subscription = false
    self.save
  end

  def subscribe
    self.active_subscription = true
    self.save
  end

  private

    def set_subscription_default
      self.active_subscription = false
    end
end
