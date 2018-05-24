# == Schema Information
# Table name: lessons
#
#  id                     :integer          not null, primary key
#  body                   :text
#  title                  :string
#  position               :integer
#  course_id               :integer          not null, foreign key

class Lesson < ApplicationRecord
  belongs_to :course

  has_one :category, through: :course
  has_many :completions, as: :completable

  validates :position,
            presence: true,
            numericality: { only_integer: true }

  acts_as_list scope: :course
  has_paper_trail

  delegate :color, :title, to: :category, prefix: true

  default_scope { order(position: :asc) }
end
