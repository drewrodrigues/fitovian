class AddActiveSubscriptionToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :active_subscription, :boolean
  end
end
