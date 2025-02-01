class AddColumnsToSchools < ActiveRecord::Migration[8.0]
  def change
    add_column :schools, :phone_number, :string
    add_column :schools, :email, :string
    add_column :schools, :box_address, :string
  end
end
