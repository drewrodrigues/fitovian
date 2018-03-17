# active                boolean
# current_period_end    date
# id                    integer           not null, unique
# stripe_id             string

class Subscription < ApplicationRecord
  belongs_to :user

  validates :stripe_id, presence: true
  validates :user, presence: true
  validates :active, presence: true
end
