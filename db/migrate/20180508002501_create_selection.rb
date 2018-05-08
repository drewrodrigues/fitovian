class CreateSelection < ActiveRecord::Migration[5.1]
  def change
    create_table :selections do |t|
      t.references :stack, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps null: false
    end
  end
end
