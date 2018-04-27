class AddIconToStacks < ActiveRecord::Migration[5.1]
  def up
    add_attachment :stacks, :icon
  end

  def down
    remove_attachment :stacks, :icon
  end
end
