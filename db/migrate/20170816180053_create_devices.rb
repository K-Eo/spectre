class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :imei, limit: 16
      t.string :os
      t.string :phone, limit: 20
      t.string :owner, limit: 120
      t.string :model

      t.timestamps
    end
    add_index :devices, :imei
  end
end
