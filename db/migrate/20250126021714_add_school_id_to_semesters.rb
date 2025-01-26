class AddSchoolIdToSemesters < ActiveRecord::Migration[8.0]
  def change
    add_reference :semesters, :school, null: false, foreign_key: true
  end
end
