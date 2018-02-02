class ChargesController < ApplicationController
  before_action :check_active_subscription, only: [:new, :create]
  protect_from_forgery except: :receive

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
      current_user.stripe_id ||= subscription.id
      current_user.set_subscription_one_month
      current_user.subscribe
      redirect_to root_path
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  def destroy
    subscription = Stripe::Subscription.retrieve(current_user.stripe_id)
    subscription.delete(at_period_end: true)
    current_user.cancel_subscription

    redirect_to edit_user_registration_path
  end

  def re_activate
    subscription = Stripe::Subscription.retrieve(current_user.stripe_id)
    subscription.items = [{
        id: subscription.items.data[0].id,
        plan: 'basic',
    }]
    subscription.save
    current_user.subscribe

    redirect_to edit_user_registration_path
  end

  def receive
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
