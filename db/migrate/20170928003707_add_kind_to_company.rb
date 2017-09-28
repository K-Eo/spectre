class AddKindToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :kind, :integer, default: 0
  end
end
