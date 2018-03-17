class AddStripeIdToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :stripe_id, :string
  end
end
