class CreateBillings < ActiveRecord::Migration[8.0]
  def change
    create_table :billings do |t|
      t.string :title
      t.decimal :amount, precision: 6, scale: 2
      t.references :student, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true

      t.timestamps
    end
  end
end
