# == Schema Information
# Table name: stacks
#
#  id                     :integer          not null, primary key
#  title                  :string

class Track < ApplicationRecord
  has_many :users

  has_many :stack_tracks, dependent: :destroy
  has_many :stacks, through: :stack_tracks

  has_attached_file :icon,
                    styles: { medium: '300x300', thumb: '100x100' }

  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\z/
  validates :title, presence: true
end
