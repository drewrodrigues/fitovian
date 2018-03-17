class RemoveColumnsFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :current_period_end
  end
end
