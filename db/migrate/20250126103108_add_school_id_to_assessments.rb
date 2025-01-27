class AddSchoolIdToAssessments < ActiveRecord::Migration[8.0]
  def change
    add_reference :assessments, :school, null: false, foreign_key: true
  end
end
