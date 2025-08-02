class AddCaseInsensitiveScopedUsernameIndexToUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :users,
              "LOWER(username), school_id",
              unique: true,
              name: "index_users_on_lower_username_and_school_id"
  end
end
