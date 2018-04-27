class Stack < ApplicationRecord
  belongs_to :category
  has_many :lessons, dependent: :destroy
  has_attached_file :icon,
                    styles: { medium: '300x300', thumb: '100x100' },
                    default_url: '/images/:style/missing.png'
  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\z/

  validates :title, presence: true
end
