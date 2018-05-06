class Completion < ApplicationRecord
	belongs_to :completable, polymorphic: true
	belongs_to :user

  validates :completable_id, presence: true
  validates :completable_type, presence: true
  validates :user, presence: true
  validates :user, uniqueness: { scope: [:completable_id, :completable_type] }
end
