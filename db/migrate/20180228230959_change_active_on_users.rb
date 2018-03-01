class ChangeActiveOnUsers < ActiveRecord::Migration[5.1]
  def change
      add_column :users, :active, :boolean, null: false, default: false
      remove_column :users, :active_subscription
  end
end
