class ChangeCurrentPeriodEndToDatetime < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :current_period_end, :datetime
  end
end
