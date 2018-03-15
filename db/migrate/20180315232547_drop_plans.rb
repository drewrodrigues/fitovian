class DropPlans < ActiveRecord::Migration[5.1]
  def change
    drop_table :plans
  end
end
