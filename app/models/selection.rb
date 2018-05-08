class Selection < ApplicationRecord
  belongs_to :stack
  belongs_to :user

  validates :stack, presence: true
  validates :user, presence: true
  validates :user, uniqueness: { scope: :stack }
end
