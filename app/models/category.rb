# == Schema Information
# Table name: categories
#
#  id                     :integer          not null, primary key
#  color                  :string
#  title                  :string

class Category < ApplicationRecord
  has_many :courses, dependent: :destroy

  validates :title, presence: true

  has_paper_trail
end
