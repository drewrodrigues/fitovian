class AddTrackToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :track, foreign_key: true
  end
end
