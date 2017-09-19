class CreateAlertEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :alert_events do |t|
      t.references :alert, foreign_key: true
      t.timestamps
    end

    add_reference :alert_events, :guard, foreign_key: { to_table: :users }
  end
end
