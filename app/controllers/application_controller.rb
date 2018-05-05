class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_plan!
    return if current_user&.admin?
    redirect_to choose_plan_path unless current_user&.plan?
  end

  def require_payment_method!
    return if current_user&.admin?
    redirect_to new_cards_path unless current_user&.payment_method?
  end

  def require_admin!
    return if current_user&.admin?
    redirect_to dashboard_path, flash: { info: 'You must be an admin.' }
  end
   
  def onboard_user!
    authenticate_user!
    return if current_user&.admin?
    require_plan!
    require_payment_method!
  end
end
