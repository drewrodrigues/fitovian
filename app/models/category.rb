class Category < ApplicationRecord
  validates :title, presence: true
  has_many :stacks, dependent: :destroy
end
