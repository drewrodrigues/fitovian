class RemoveTimestampsFromTables < ActiveRecord::Migration[5.1]
  def change
    [:categories, :lessons, :stacks].each do |table|
      remove_columns table, :created_at, :updated_at
    end
  end
end
