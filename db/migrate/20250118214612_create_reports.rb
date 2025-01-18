class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.decimal :class_score
      t.decimal :exam_score
      t.decimal :total
      t.string :grade
      t.string :remarks
      t.references :student, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reports, :grade

  end
end
