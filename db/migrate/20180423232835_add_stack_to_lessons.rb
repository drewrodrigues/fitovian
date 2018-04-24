class AddStackToLessons < ActiveRecord::Migration[5.1]
  def change
    add_reference :lessons, :stack, foreign_key: true
  end
end
