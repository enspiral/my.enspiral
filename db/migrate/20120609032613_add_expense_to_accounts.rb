class AddExpenseToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :expense, :boolean, default: false, null: false
    add_index :accounts, :expense
    add_column :companies, :outgoing_account_id, :integer
  end
end
