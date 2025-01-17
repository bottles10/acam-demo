class CreateSubjectTeachers < ActiveRecord::Migration[8.0]
  def change
    create_table :subject_teachers do |t|
      t.references :subject, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :subject_teachers, [:subject_id, :teacher_id], unique: true
  end
end
