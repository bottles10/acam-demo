class AddFerrumSessionTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :ferrum_session_token, :string
    add_index :users, :ferrum_session_token, unique: true
  end
end
