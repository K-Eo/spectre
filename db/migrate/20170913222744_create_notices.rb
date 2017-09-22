class CreateNotices < ActiveRecord::Migration[5.1]
  def change
    create_table :notices do |t|
      t.references :alert, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
