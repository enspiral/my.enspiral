class RenameCompaniesAccountToAccountsCompany < ActiveRecord::Migration
  def up
    rename_table :companies_accounts, :accounts_companies
  end

  def down
    rename_table :accounts_companies, :companies_accounts
  end
end
