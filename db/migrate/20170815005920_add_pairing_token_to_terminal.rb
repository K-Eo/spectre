class AddPairingTokenToTerminal < ActiveRecord::Migration[5.1]
  def change
    add_column :terminals, :pairing_token, :string
    add_index :terminals, :pairing_token
  end
end
