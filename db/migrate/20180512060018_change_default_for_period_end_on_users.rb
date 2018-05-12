class ChangeDefaultForPeriodEndOnUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :period_end, nil
  end
end
