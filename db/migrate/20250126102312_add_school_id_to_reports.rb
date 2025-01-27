class AddSchoolIdToReports < ActiveRecord::Migration[8.0]
  def change
    add_reference :reports, :school, null: false, foreign_key: true
  end
end
