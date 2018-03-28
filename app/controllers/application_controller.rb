class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :require_plan!

  private

  def require_plan!
    redirect_to choose_plan_path unless current_user.has_plan?
  end
end
