class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

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

  def subscription_active?
    return false unless current_period_end
    self.current_period_end > Date.current
  end
end
