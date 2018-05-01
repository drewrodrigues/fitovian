class CreateStackTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :stack_tracks do |t|
      t.references :track, foreign_key: true, null: false
      t.references :stack, foreign_key: true, null: false
    end
  end
end
