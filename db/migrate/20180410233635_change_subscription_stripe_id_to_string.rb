class ChangeSubscriptionStripeIdToString < ActiveRecord::Migration[5.1]
  def change
    change_column :subscriptions, :stripe_id, :string
  end
end
