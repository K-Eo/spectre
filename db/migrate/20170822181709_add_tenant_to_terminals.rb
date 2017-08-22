class AddTenantToTerminals < ActiveRecord::Migration[5.1]
  def change
    add_reference :terminals, :tenant, foreign_key: true
  end
end
