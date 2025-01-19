class AddYearTermIndexToSemester < ActiveRecord::Migration[8.0]
  def change
    add_index :semesters, [:year, :term], unique: true
  end
end
