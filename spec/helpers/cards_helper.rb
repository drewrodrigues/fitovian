module CardsHelper
  def add_fake_card(user, default=false)
    token = StripeMock.create_test_helper.generate_card_token
    card = StripeHandler.new(user).customer.sources.create(source: token)
    user.cards << Card.new(
      stripe_id: card.id, last4: card.last4, default: default
    )
  end
end
