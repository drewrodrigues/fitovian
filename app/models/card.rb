# default           boolean           not null, default(false)
# id                integer           not null, unique
# last4             string            not null
# stripe_id         string            not null

class Card < ApplicationRecord
  belongs_to :user

  validates_presence_of :last4
  validates_presence_of :stripe_id
  validates_presence_of :user

  before_save :ensure_only_default_payment_method

  def ensure_only_default_payment_method
    count = self.user.cards.where(default: true).count
    throw :abort if count > 1
  end
end
