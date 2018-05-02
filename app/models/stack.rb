# == Schema Information
# Table name: stacks
#
#  id                     :integer          not null, primary key
#  category_id            :id               not null, foreign key
#  icon                   :file
#  title                  :string

# Stacks can be thought of as courses. They belong to a category and have
# lessons. Each stack has a icon to uniquely identify it visually.
class Stack < ApplicationRecord
  belongs_to :category

  has_paper_trail
  has_many :lessons, dependent: :destroy
  has_many :stack_tracks, dependent: :destroy
  has_many :tracks, through: :stack_tracks
  has_attached_file :icon,
                    styles: { medium: '300x300', thumb: '100x100' }

  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\z/
  validates :category, presence: true
  validates :title, presence: true
end
