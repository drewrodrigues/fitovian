class RemoveUnneededColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :stripe_subscription_id
  end
end
