class AddTerminalRefCurrentToDevice < ActiveRecord::Migration[5.1]
  def change
    add_reference :devices, :terminal, foreign_key: true
    add_column :devices, :current, :boolean, default: true
  end
end
