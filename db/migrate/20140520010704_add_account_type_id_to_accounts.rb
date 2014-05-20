class AddAccountTypeIdToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :account_type_id, :integer
  end
end
