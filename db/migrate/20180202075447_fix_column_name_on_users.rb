class FixColumnNameOnUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :stipe_subscription_id, :stripe_subscription_id
  end
end
