class AddContactToExternalTransactions < ActiveRecord::Migration
  def change
    add_column :external_transactions, :contact, :string
  end
end
