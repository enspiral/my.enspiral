class AddActiveToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :active, :boolean, null: false, default: true
    add_index :companies, :active
  end
end
