class AddKindFieldToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :kind, :string
  end
end
