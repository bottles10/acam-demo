class AddMottoToSchools < ActiveRecord::Migration[8.0]
  def change
    add_column :schools, :motto, :string
  end
end
