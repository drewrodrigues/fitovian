class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :ensure_within_period_end!

  def require_admin!
    return if current_user&.admin?
    redirect_to dashboard_path, flash: { info: 'You must be an admin.' }
  end

  def ensure_within_period_end!
    return true if current_user.admin
    if !current_user.active?
      redirect_to billing_path, flash: {
        alert: 'Please subscribe to continue!'
      }
    end
  end
end
