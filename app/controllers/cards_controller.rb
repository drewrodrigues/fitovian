class CardsController < ApplicationController
  skip_before_action :require_payment_method!, on: [:new, :create]

  def new; end

  def create
    new_user = current_user.cards.empty?
    if current_user.add_card(params[:stripeToken])
      if new_user
        current_user.subscribe
        path = lessons_path
        message = "Successfully subscribed to #{current_user.plan.name} plan"
      else
        path = billing_path
        message = 'Successfully updated payment method'
      end
      redirect_to path, flash: {
        success: message
      }
    else
      flash.now[:alert] = 'Failed to add payment method'
      render 'new'
    end
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: {
      alert: e.message
    }
  end

  def default
    card = current_user.cards.find(params[:id])
    if card == current_user.default_card || current_user.default_card(card)
      redirect_to billing_path, flash: {
        success: 'Successfully set default payment method'
      }
    else
      redirect_to billing_path, flash: {
        alert: 'Failed to update default card'
      }
    end
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: {
      alert: e.message
    }
  end

  def destroy
    card = current_user.cards.find(params[:id])
    if current_user.delete_card(card)
      redirect_to billing_path, flash: {
        success: 'Successfully deleted payment method'
      }
    else
      redirect_to billing_path, flash: {
        alert: 'Failed to delete payment method'
      }
    end
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: {
      alert: e.message
    }
  end
end
