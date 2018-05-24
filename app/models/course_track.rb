class CourseTrack < ApplicationRecord
  belongs_to :course
  belongs_to :track

  validates :course, presence: true
  validates :track, presence: true
end
