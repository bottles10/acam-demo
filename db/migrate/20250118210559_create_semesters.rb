class CreateSemesters < ActiveRecord::Migration[8.0]
  def change
    create_table :semesters do |t|
      t.date :year
      t.integer :term

      t.timestamps
    end
  end
end
