class AddStateToAlert < ActiveRecord::Migration[5.1]
  def change
    add_column :alerts, :state, :integer, default: 0
  end
end
