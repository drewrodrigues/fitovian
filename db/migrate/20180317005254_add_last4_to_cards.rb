class AddLast4ToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :last4, :string
  end
end
