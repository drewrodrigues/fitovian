class Completion < ApplicationRecord
  self.primary_key = 'user_id'

	belongs_to :completable, polymorphic: true
	belongs_to :user
end
