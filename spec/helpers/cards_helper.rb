module CardsHelper
  def add_fake_card(user)
    token = StripeMock.create_test_helper.generate_card_token
    card = user.stripe_customer.sources.create(source: token)
    user.cards << Card.new(stripe_id: card.id, last4: card.last4, default: true)
  end
end
