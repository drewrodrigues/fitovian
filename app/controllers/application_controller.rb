class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :require_plan!
  before_action :require_payment_method!

  private

  def require_plan!
    return if current_user && current_user.admin?
    redirect_to choose_plan_path unless current_user && current_user.plan?
  end

  def require_payment_method!
    return if current_user && current_user.admin?
    redirect_to new_cards_path unless current_user && current_user.payment_method?
  end
end
