# default           boolean           not null, default(false)
# id                integer           not null, unique
# last4             string            not null
# stripe_id         string            not null

class Card < ApplicationRecord
  belongs_to :user

  validates_presence_of :last4
  validates_presence_of :stripe_id
  validates_presence_of :user

  # create a card and add the card to stripe
  def self.add(user, token)
    stripe_customer = user.stripe_customer
    stripe_card = stripe_customer.sources.create(source: token)
    card = Card.create(user_id: user.id, stripe_id: stripe_card.id, last4: stripe_card.last4)
  end
end
