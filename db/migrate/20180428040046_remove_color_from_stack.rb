class RemoveColorFromStack < ActiveRecord::Migration[5.1]
  def change
  remove_column :stacks, :color
  end
end
