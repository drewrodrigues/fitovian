class AddCurrentPeriodEndToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :current_period_end, :date
    add_column :subscriptions, :active, :boolean
  end
end
