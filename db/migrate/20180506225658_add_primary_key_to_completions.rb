class AddPrimaryKeyToCompletions < ActiveRecord::Migration[5.1]
  def change
    add_column :completions, :id, :primary_key
  end
end
