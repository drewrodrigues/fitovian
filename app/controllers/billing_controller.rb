class BillingController < ApplicationController
  skip_before_action :ensure_within_period_end!

  def dashboard
    @cards = current_user.cards
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
