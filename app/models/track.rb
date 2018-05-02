# == Schema Information
# Table name: stacks
#
#  id                     :integer          not null, primary key
#  title                  :string

class Track < ApplicationRecord
  has_many :stack_tracks, dependent: :destroy
  has_many :stacks, through: :stack_tracks

  validates :title, presence: true
end
