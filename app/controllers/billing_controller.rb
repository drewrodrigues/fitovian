class BillingController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_active_subscription, only: [:new, :create]
  protect_from_forgery except: :receive

  def dashboard
  end

  def new
  end

  def subscribe
    begin
      current_user.add_payment_method(params[:stripe_token])
      current_user.subscribe
      redirect_to root_path, flash: {success: 'Successfully subscribed'}
    rescue => e
      flash.now[:alert] = e.message
      render "new"
    end
  end

  def cancel
    begin
      current_user.cancel
      flash.now[:success] = 'Successfully canceled subscription'
      render "new"
    rescue => e
      flash.now[:alert] = e.message
      render "new", alert: e.message
    end
  end

  def re_activate
    begin
      current_user.re_activate
      flash.now[:success] = 'Successfully re-activated subscription'
      render 'new'
    rescue => e
      flash.now[:alert] = e.message
      render 'new'
    end
  end

  def update
    begin
      current_user.add_payment_method(params[:stripe_token])
      redirect_to dashboard_path, flash: {success: 'Successfully updated payment method'}
    rescue => e
      flash.now[:alert] = e.message
      render 'update'
    end
  end

  def receive
    # TODO: test through integration
    data = params['data']['object']
    stripe_id = data['id']
    user = User.find_by(id: stripe_id)
    type = params['type']

    if type == 'charge.succeeded'
      user.set_end_date(data)
    end
  end
end
