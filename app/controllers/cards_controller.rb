class CardsController < ApplicationController
  skip_before_action :require_payment_method!, on: %i[new create]

  def new; end

  def create
    if current_user.add_card(params[:stripeToken])
      current_user.subscribe
      redirect_to lessons_path, flash: {
        success: "Successfully subscribed to #{current_user.plan.name} plan"
      }
    else
      flash.now[:alert] = 'Failed to add payment method'
      render 'new'
    end
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: { alert: e.message }
  end

  def update
    if current_user.add_card(params[:stripeToken])
      redirect_to billing_path, flash: {
        success: 'Successfully updated payment method'
      }
    else
      flash.now[:alert] = 'Failed to add payment method'
      render 'new'
    end
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: { alert: e.message }
  end

  def default
    card = current_user.cards.find(params[:id])
    message = if current_user.default_card(card)
                { success: 'Successfully set default payment method' }
              else
                { alert: 'Failed to update default card' }
              end
    redirect_to billing_path, flash: message
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: { alert: e.message }
  end

  def destroy
    card = current_user.cards.find(params[:id])
    message = if current_user.delete_card(card)
                { success: 'Successfully deleted payment method' }
              else
                { alert: 'Failed to delete payment method' }
              end
    redirect_to billing_path, flash: message
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: { alert: e.message }
  end
end
