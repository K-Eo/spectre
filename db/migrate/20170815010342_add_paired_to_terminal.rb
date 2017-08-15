class AddPairedToTerminal < ActiveRecord::Migration[5.1]
  def change
    add_column :terminals, :paired, :boolean, default: false
  end
end
