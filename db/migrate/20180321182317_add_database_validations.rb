class AddDatabaseValidations < ActiveRecord::Migration[5.1]
  def change
    change_column_null :cards, :user_id, false
    change_column_null :cards, :stripe_id, false
    change_column_null :cards, :last4, false
    change_column :cards, :default, :boolean, default: false, null: false

    change_column_null :plans, :user_id, false
    change_column_null :plans, :name, false
    change_column_null :plans, :price, false
    change_column_null :plans, :stripe_id, false

    change_column_null :subscriptions, :user_id, false
    change_column_null :subscriptions, :stripe_id, false
    change_column_null :subscriptions, :current_period_end, false
    change_column :subscriptions, :active, :boolean, default: false, null: false
    change_column :subscriptions, :subscribed, :boolean, default: false, null: false

    remove_column :users, :last4
  end
end
