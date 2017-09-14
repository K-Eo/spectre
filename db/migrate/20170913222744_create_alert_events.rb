class CreateAlertEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :alert_events do |t|
      t.references :user, foreign_key: true
      t.references :alert, foreign_key: true

      t.timestamps
    end
  end
end
