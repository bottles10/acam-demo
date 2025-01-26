class CreateSchools < ActiveRecord::Migration[8.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :subdomain

      t.timestamps
    end
    
    add_index :schools, :subdomain, unique: true
    
  end
end
