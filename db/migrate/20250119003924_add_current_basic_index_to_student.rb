class AddCurrentBasicIndexToStudent < ActiveRecord::Migration[8.0]
  def change
    add_index :students, :current_basic
  end
end
