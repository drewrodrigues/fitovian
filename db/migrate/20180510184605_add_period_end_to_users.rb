class AddPeriodEndToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :period_end, :date, null: false, default: Date.today + 3
  end
end
