class RenameCompaniesAccountToAccountsCompany < ActiveRecord::Migration
  def up
    if table_exists? :accounts_companies
      drop_table :accounts_companies
    end
    rename_table :companies_accounts, :accounts_companies
  end

  def down
    rename_table :accounts_companies, :companies_accounts
  end
end
