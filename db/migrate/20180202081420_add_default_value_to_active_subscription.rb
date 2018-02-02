class AddDefaultValueToActiveSubscription < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :active_subscription, :boolean, default: false
  end
end
