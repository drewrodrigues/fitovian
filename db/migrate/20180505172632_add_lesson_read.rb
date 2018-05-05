class AddLessonRead < ActiveRecord::Migration[5.1]
  def change
	  create_table :completions, id: false do |t|
		  t.integer :user_id
		  t.integer :completable_id
		  t.string :completable_type
		  t.timestamps
	  end

	  add_index :completions, [:completable_type, :completable_id]
	  add_index :completions, :user_id
  end
end
