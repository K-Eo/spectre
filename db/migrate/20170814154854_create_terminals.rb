class CreateTerminals < ActiveRecord::Migration[5.1]
  def change
    create_table :terminals do |t|
      t.string :name
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :terminals, :name
    add_index :terminals, :status
  end
end
