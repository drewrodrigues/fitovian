class Lesson < ApplicationRecord
  validates :position,
            presence: true,
            numericality: { only_integer: true }
  belongs_to :stack
end
