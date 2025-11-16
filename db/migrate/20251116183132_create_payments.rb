class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.string :email
      t.integer :amount
      t.string :reference
      t.string :status

      t.timestamps
    end
  end
end
