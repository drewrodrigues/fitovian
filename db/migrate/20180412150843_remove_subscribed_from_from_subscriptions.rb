class RemoveSubscribedFromFromSubscriptions < ActiveRecord::Migration[5.1]
  def change
    remove_column :subscriptions, :subscribed
  end
end
