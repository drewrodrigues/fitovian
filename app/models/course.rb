# == Schema Information
# Table name: courses
#
#  id                     :integer          not null, primary key
#  category_id            :id               not null, foreign key
#  icon                   :file
#  title                  :string

class Course < ApplicationRecord
  default_scope { order(title: :asc) }

  belongs_to :category

  has_paper_trail
  has_many :completions, as: :completable
  has_many :lessons, dependent: :destroy
  has_many :selections, dependent: :destroy
  has_many :course_tracks, dependent: :destroy
  has_many :tracks, through: :course_tracks
  has_many :users, through: :selections
  has_attached_file :icon,
                    styles: { medium: '300x300', thumb: '100x100' }

  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\z/
  validates :category, presence: true
  validates :title, presence: true

  delegate :color, :title, to: :category, prefix: true
end
