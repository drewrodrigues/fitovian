class AddColorToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :color, :string
  end
end
