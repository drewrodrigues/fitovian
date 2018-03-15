class Plan < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :price, presence: true
  validates :user, presence: true
end
