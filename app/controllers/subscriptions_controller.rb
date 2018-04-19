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
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: {
      alert: e.message
    }
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
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: {
      alert: e.message
    }
  end
end