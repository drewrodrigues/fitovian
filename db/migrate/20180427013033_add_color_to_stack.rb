class AddColorToStack < ActiveRecord::Migration[5.1]
  def change
    add_column :stacks, :color, :string
  end
end
