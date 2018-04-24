class Stack < ApplicationRecord
  belongs_to :category
  has_many :lessons, dependent: :destroy
  validates :title, presence: true
end
