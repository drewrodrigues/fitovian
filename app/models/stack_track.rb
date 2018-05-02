class StackTrack < ApplicationRecord
  belongs_to :stack
  belongs_to :track

  validates :stack, presence: true
  validates :track, presence: true
end
