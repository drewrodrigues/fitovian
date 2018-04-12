class SubscriptionsController < ApplicationController
  def create
    if current_user.subscribe
      redirect_to billing_path, flash: {
        success: "Successfully subscribed to #{current_user.plan.name} plan"
      }
    else
      redirect_to billing_path, flash: {
        alert: 'Failed to subscribe'
      }
    end
  end

  def re_activate
    if current_user.re_activate
      redirect_to billing_path, flash: {
        success: 'Successfully re-activated membership'
      }
    else
      redirect_to billing_path, flash: {
        alert: 'Failed to re-activate membership'
      }
    end
  end

  def cancel
    if current_user.cancel
      redirect_to billing_path, flash: {
        success: 'Successfully canceled membership'
      }
    else
      redirect_to billing_path, flash: {
        alert: 'Failed to cancel membership'
      }
    end
  end
end