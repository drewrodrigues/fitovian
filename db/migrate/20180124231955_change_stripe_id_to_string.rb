class ChangeStripeIdToString < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :stripe_id, :string
  end
end
