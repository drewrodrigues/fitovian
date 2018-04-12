class CardsController < ApplicationController
  before_action :set_stripe_customer, on: [:create, :default, :destroy]
  skip_before_action :require_payment_method!, on: [:new, :create]

  def new; end

  def create
    stripe_customer = current_user.stripe_customer
    new_payment_method = stripe_customer.sources.create(source: params[:stripeToken])
    @card = current_user.cards.new(stripe_id: new_payment_method.id, last4: new_payment_method.last4)
    if !current_user.payment_method? && @card.save && current_user.subscribe
      update_defaults
      redirect_to lessons_path, flash: {
        success: "Successfully subscribed to #{current_user.plan.name} plan"
      }
    elsif @card.save
      update_defaults
      redirect_to billing_path, flash: {
        success: 'Successfully updated payment method'
      }
    else
      flash.now[:info] = 'Failed add payment method'
      render 'new'
    end
  rescue Stripe::StripeError => e
    flash.now[:alert] = e.message
    redirect_to billing_path
  end

  def default
    @card = current_user.cards.find(params[:id])
    if @card == current_user.default_card || update_defaults
      redirect_to billing_path, flash: {
        success: 'Successfully set default payment method'
      }
    else
      redirect_to billing_path, flash: {
        alert: 'Failed to set default payment method'
      }
    end
  end

  def destroy
    @card = current_user.cards.find(params[:id])
    if @card != current_user.default_card && @card.destroy
      @stripe_customer.sources.retrieve(@card.stripe_id).delete
      redirect_to billing_path, flash: {
        success: 'Successfully deleted payment method'
      }
    else
      redirect_to billing_path, flash: {
        alert: 'Failed to delete payment method'
      }
    end
  end

  private

  def update_defaults
    update_stripe_card_default
    update_user_card_default
  end

  def update_stripe_card_default
    @stripe_customer.default_source = @card.stripe_id
    @stripe_customer.save
  end

  def update_user_card_default
    previous_default = current_user.default_card
    if previous_default
      previous_default.default = false
      previous_default.save
    end
    @card.default = true
    @card.save
  end

  def set_stripe_customer
    @stripe_customer = current_user.stripe_customer
  end
end
