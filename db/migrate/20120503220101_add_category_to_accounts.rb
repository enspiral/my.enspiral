class AddCategoryToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :category, :string
  end
end
