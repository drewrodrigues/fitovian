class PlansController < ApplicationController
  skip_before_action :require_plan!
  skip_before_action :require_payment_method!

  def new; end

  def create
    new_plan = !current_user.plan?
    plan = current_user.build_plan(Plan.const_get(plan_params[:plan].upcase))
    if plan.save
      if new_plan
        redirect_to new_cards_path, flash:
          { success: "Successfully chose #{plan[:name]} plan" }
      else
        redirect_to billing_path, flash:
          { success: "Successfully chose #{plan[:name]} plan" }
      end
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
