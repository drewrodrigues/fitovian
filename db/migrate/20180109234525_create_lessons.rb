class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.string :title
      t.text :body
      t.integer :position
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
