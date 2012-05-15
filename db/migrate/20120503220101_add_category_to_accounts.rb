class AddCategoryToAccounts < ActiveRecord::Migration
  def change
    #this was moved back to UserAccountsSetup to avoid error.
    #add_column :accounts, :category, :string
  end
end
