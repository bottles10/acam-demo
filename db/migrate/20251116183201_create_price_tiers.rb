class CreatePriceTiers < ActiveRecord::Migration[8.0]
  def change
    create_table :price_tiers do |t|
      t.integer :min_students
      t.integer :max_students
      t.integer :price

      t.timestamps
    end
  end
end
