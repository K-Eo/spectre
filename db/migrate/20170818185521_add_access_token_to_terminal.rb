class AddAccessTokenToTerminal < ActiveRecord::Migration[5.1]
  def change
    add_column :terminals, :access_token, :string
    add_index :terminals, :access_token, unique: true
  end
end
