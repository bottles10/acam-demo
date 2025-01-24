class ChangeGradeTypeInReports < ActiveRecord::Migration[8.0]
  def change
    change_column :reports, :grade, :integer, using: 'grade::integer'
  end
end
