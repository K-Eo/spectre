class AddMonitorCreateAlertToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :monitor, :boolean, default: false
    add_column :users, :create_alert, :boolean, default: false
  end
end
