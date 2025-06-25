class UpdateEmailUniquenessToBeScopedBySchool < ActiveRecord::Migration[8.0]
  def change
    remove_index :users, :email # removes the global unique index

    # add a new unique index scoped to school_id
    add_index :users, [:school_id, :email], unique: true
  end
end
