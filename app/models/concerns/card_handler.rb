class CardHandler
  def initialize(user)
    @user = user
    @stripe = StripeHandler.new(user)
  end

  def add(token)
    Card.transaction do
      @card = add_card(add_stripe_card(token))
      default(@card)
    end
  end

  def delete(card)
    @card = @user.cards.find_by(id: card) if card
    return false if @card.default

    Card.transaction do
      begin
        @stripe.customer.sources.retrieve(@card.stripe_id).delete
        @card.destroy
      rescue Stripe::StripeError
        raise ActiveRecord::Rollback
      end
    end
  end

  def default(card)
    @card = @user.cards.find_by(id: card) if card
    return false unless @card
    return true if @card == @user.default_card

    Card.transaction do
      begin
        remove_previous_default
        set_default(@card)
        set_stripe_default(@card)
      rescue Stripe::StripeError
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def add_card(stripe_card)
    @user.cards.create!(stripe_id: stripe_card.id,
                       last4: stripe_card.last4)
  end

  def add_stripe_card(token)
    stripe_customer = @stripe.customer
    stripe_customer.sources.create(source: token)
  rescue Stripe::StripeError
    raise ActiveRecord::Rollback
  end

  def set_default(card)
    card.default = true
    card.save!
  end

  def remove_previous_default
    previous_default = @user.default_card
    return true unless previous_default
    previous_default.default = false
    previous_default.save!
  end

  def set_stripe_default(card)
    customer = @stripe.customer
    customer.default_source = card.stripe_id
    customer.save
  end
end
