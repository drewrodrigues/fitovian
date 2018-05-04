class AddIconToTracks < ActiveRecord::Migration[5.1]
  def up
    add_attachment :tracks, :icon
  end

  def down
    remove_attachment :tracks, :icon
  end
end
