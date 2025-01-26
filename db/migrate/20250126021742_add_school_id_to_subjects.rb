class AddSchoolIdToSubjects < ActiveRecord::Migration[8.0]
  def change
    add_reference :subjects, :school, null: false, foreign_key: true
  end
end
