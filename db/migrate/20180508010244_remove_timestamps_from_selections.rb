class RemoveTimestampsFromSelections < ActiveRecord::Migration[5.1]
  def change
    remove_column :selections, :created_at, :string
    remove_column :selections, :updated_at, :string
  end
end
