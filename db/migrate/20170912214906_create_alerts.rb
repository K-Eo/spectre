class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.string :text
      t.references :company, foreign_key: true
      t.timestamps
    end

    add_reference :alerts, :issuing, foreign_key: { to_table: :users }
  end
end
