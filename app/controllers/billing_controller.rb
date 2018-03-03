class BillingController < ApplicationController
  before_action :check_active_subscription, only: [:new, :create]
  protect_from_forgery except: :receive

  def new
  end

  def create
    begin
      current_user.add_payment_method(params[:stripeToken])
      current_user.subscribe
      redirect_to root_path, notice: 'Successfully subscribed.'
    rescue => e
      redirect_to new_charge_path, alert: e.message
    end
  end

  def destroy
    begin
      current_user.cancel_subscription
      redirect_to edit_user_registration_path, notice: 'Successfully canceled subscription.'
    rescue => e
      redirect_to edit_user_registration_path, alert: e.message
    end
  end

  def re_activate
    begin
      current_user.re_activate
      redirect_to edit_user_registration_path, notice: 'Successfully re-activated subscription.'
    rescue => e
      redirect_to edit_user_registration_path, alert: e.message
    end
  end

  def update
  end

  def receive
    # TODO: test & stub out
    data = params['data']['object']
    stripe_id = data['id']
    user = User.find_by(id: stripe_id)
    type = params['type']

    if type == 'charge.succeeded'
      user.set_subscription_one_month
    end
  end

  private
    def check_active_subscription
      redirect_to root_path if current_user.membership_active?
    end
end
