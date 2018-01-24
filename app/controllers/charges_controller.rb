class ChargesController < ApplicationController
  before_action :check_active_subscription, only: [:new, :create]
  layout 'logged_in'

  def new
  end

  def create
    customer = Stripe::Customer.create(
      email: current_user.email,
      source: params[:stripeToken]
    )

    subscription = Stripe::Subscription.create({
      customer: customer.id,
      items: [{plan: 'basic'}],
    })

    if subscription.status == 'active'
      current_user.set_subscription_one_month
      redirect_to root_path
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  def receive
  end

  private
    def check_active_subscription
      redirect_to root_path if current_user.subscription_active?
    end
end