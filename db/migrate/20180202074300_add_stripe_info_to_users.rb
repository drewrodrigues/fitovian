class AddStripeInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :stipe_subscription_id, :string
    remove_column :users, :stripe_id
  end
end
