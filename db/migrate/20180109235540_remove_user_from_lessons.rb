class RemoveUserFromLessons < ActiveRecord::Migration[5.1]
  def change
    remove_reference :lessons, :user, index: true
  end
end
