class CreateCutoffs < ActiveRecord::Migration[8.0]
  def change
    create_table :cutoffs do |t|
      t.integer :current_basic
      t.integer :class_percentage
      t.integer :exam_percentage

      t.timestamps
    end
  end
end
