class PlansController < ApplicationController
  skip_before_action :require_plan!
  # skip_before_action :require_payment_method!

  def new; end

  def create
    plan = current_user.build_plan(Plan.send(plan_params[:name]))
    if plan.save
      redirect_to billing_path,
        flash: { success: "Successfully chose #{ plan[:name] } plan" }
    else
      flash.now[:alert] = 'Failed to change plan'
      render 'new'
    end
  end

  private

  def plan_params
    params.permit(:name)
  end
end
