# == Schema Information
# Table name: courses
#
#  id                     :integer          not null, primary key
#  title                  :string

class Track < ApplicationRecord
  has_many :users

  has_one_attached :icon
  has_many :completions, as: :completable
  has_many :course_tracks, dependent: :destroy
  has_many :courses, through: :course_tracks

  validates :title, presence: true
end
