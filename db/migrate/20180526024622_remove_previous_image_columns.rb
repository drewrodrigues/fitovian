class RemovePreviousImageColumns < ActiveRecord::Migration[5.2]
  def change
    [:tracks, :courses].each do |table|
      remove_column table, :icon_file_name
      remove_column table, :icon_content_type
      remove_column table, :icon_file_size
      remove_column table, :icon_updated_at
    end
  end
end
