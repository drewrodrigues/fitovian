class ChangeStripeCustomerIdOnUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :stripe_customer_id, :stripe_id
  end
end
