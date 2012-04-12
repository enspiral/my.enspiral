class CreateCompaniesAccounts < ActiveRecord::Migration
  def change
    create_table :companies_accounts, :force => true do |t|
      t.integer :company_id
      t.integer :account_id

      t.timestamps
    end
    add_index :companies_accounts, :company_id
    add_index :companies_accounts, :account_id
  end
end
