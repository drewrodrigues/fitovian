class CreateStacks < ActiveRecord::Migration[5.1]
  def change
    create_table :stacks do |t|
      t.string :title
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
