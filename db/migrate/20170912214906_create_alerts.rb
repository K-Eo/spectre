class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.string :text
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.timestamps
    end
  end
end
