class PlansController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    if current_user.send("select_#{plan_params[:plan]}_plan")
      redirect_to new_cards_path, flash: {
        success: "Successfully chose #{current_user.plan.name} plan"
      }
    else
      flash.now[:alert] = 'Failed to set plan'
      render 'new'
    end
  end

  private

  def plan_params
    params.permit(:plan)
  end
end
