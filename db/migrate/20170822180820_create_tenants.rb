class CreateTenants < ActiveRecord::Migration[5.1]
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :organization

      t.timestamps
    end
    add_index :tenants, :organization
  end
end
