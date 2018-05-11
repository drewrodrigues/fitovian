class CardsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    if CardHandler.new(current_user).add(params[:stripeToken])
      redirect_to billing_path, flash: {
        success: 'Successfully added card'
      }
    else
      flash.now[:alert] = 'Failed to add payment method'
      render 'new'
    end
  end

  def default
    message = if CardHandler.new(current_user).default(params[:id])
                { success: 'Successfully set default payment method' }
              else
                { alert: 'Failed to update default card' }
              end
    redirect_to billing_path, flash: message
  end

  def destroy
    message = if CardHandler.new(current_user).delete(params[:id])
                { success: 'Successfully deleted payment method' }
              else
                { alert: 'Failed to delete payment method' }
              end
    redirect_to billing_path, flash: message
  end
end
