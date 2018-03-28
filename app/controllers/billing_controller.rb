class BillingController < ApplicationController
  # skip_before_action :require_payment_method!, on: [:new, :create]

  def new; end

  def create
    current_user.add_payment_method(params[:stripeToken])
    current_user.subscribe
    redirect_to billing_path, flash: {
      success: 'Successfully subscribed'
    }
  rescue Stripe::StripeError, RuntimeError => e
    flash.now[:alert] = e.message
    redirect_to billing_path
  end

  def update; end

  def dashboard; end

  def subscribe
    if current_user.re_activate || current_user.subscribe
      redirect_to billing_path, flash: { success: 'Successfully subscribed' }
    end
  rescue Stripe::StripeError => e
    redirect_to billing_path, flash: { alert: e.message }
  end

  def cancel
    current_user.cancel
    redirect_to billing_path, flash: { success: 'Successfully canceled subscription' }
  rescue Stripe::StripeError
    flash.now[:alert] = e.message
    redirect_to billing_path
  end

  def receive
    # TODO: test through integration
    data = params['data']['object']
    stripe_id = data['id']
    user = User.find_by(id: stripe_id)
    type = params['type']

    user.end_date(data) if type == 'charge.succeeded'
  end
end
