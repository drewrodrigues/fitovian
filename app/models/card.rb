# id                integer           not null, unique
# stripe_id         string
# last4             string

class Card < ApplicationRecord
  belongs_to :user

  validates :stripe_id, presence: true
  validates :last4, presence: true
  validates :user, presence: true
end
