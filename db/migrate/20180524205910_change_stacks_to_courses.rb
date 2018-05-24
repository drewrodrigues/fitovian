class ChangeStacksToCourses < ActiveRecord::Migration[5.2]
  def change
    rename_table :stacks, :courses
    rename_table :stack_tracks, :course_tracks
    rename_column :lessons, :stack_id, :course_id
    rename_column :selections, :stack_id, :course_id
    rename_column :course_tracks, :stack_id, :course_id
  end
end
