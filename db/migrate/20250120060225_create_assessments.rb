class CreateAssessments < ActiveRecord::Migration[8.0]
  def change
    create_table :assessments do |t|
      t.integer :attendance_present
      t.integer :attendance_total
      t.string :attitude
      t.string :conduct
      t.string :interest
      t.string :class_teacher_remarks
      t.string :form_master
      t.references :student, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true

      t.timestamps
    end
  end
end
