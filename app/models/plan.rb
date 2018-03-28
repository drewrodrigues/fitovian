# Table
###############################################################################
# id                integer
# name              string
# price             float
# stripe_id         string

class Plan < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :price, presence: true
  validates :user, presence: true
  
  validate :is_valid_plan?

  def self.basic
    {
      stripe_id: 'basic',
      name: 'basic',
      price: 1999
    }
  end

  def self.premium
    {
      stripe_id: 'premium',
      name: 'premium',
      price: 3999
    }
  end

  private

  def is_valid_plan?
    [:name, :stripe_id, :price].each do |attribute|
      self_attribute = self.send(attribute)
      errors.add(:plan, 'not valid') unless self_attribute == Plan.basic[attribute] || self_attribute == Plan.premium[attribute]
    end
  end
end
