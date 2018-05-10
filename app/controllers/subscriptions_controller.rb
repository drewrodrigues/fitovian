class SubscriptionsController < ApplicationController
  def create
    message = if SubscriptionHandler.new(current_user).subscribe
                { success: "Successfully subscribed" }
              else
                { alert: 'Failed to subscribe' }
              end
    redirect_to billing_path, flash: message
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: { alert: e.message }
  end

  def cancel
    message = if SubscriptionHandler.new(current_user).cancel
                { success: 'Successfully canceled membership' }
              else
                { alert: 'Failed to cancel membership' }
              end
    redirect_to billing_path, flash: message
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: { alert: e.message }
  end
end
