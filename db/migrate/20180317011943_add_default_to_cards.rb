class AddDefaultToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :default, :boolean
  end
end
