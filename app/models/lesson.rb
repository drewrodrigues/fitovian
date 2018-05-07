# == Schema Information
# Table name: lessons
#
#  id                     :integer          not null, primary key
#  body                   :text
#  title                  :string
#  position               :integer
#  stack_id               :integer          not null, foreign key

# Lessons are where the core content lie. They are text based and belong to
# a Stack, also known as a course.
class Lesson < ApplicationRecord
  belongs_to :stack
  
  has_one :category, through: :stack
  has_many :completions, as: :completable

  validates :position,
            presence: true,
            numericality: { only_integer: true }

  has_paper_trail

  delegate :color, :title, to: :category, prefix: true
end
