class AddSubscribedToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :subscribed, :boolean
  end
end
