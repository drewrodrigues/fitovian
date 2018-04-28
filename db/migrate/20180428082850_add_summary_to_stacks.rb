class AddSummaryToStacks < ActiveRecord::Migration[5.1]
  def change
    add_column :stacks, :summary, :string
  end
end
