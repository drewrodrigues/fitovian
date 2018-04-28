# == Schema Information
# Table name: categories
#
#  id                     :integer          not null, primary key
#  color                  :string
#  title                  :string

# Categories are the top level model. They have stacks that belong to them
# and lessons that belong to the stacks.
class Category < ApplicationRecord
  has_many :stacks, dependent: :destroy

  validates :title, presence: true

  has_paper_trail
end
