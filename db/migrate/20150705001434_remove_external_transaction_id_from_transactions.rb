class RemoveExternalTransactionIdFromTransactions < ActiveRecord::Migration
  def up
    remove_column :transactions, :external_transaction_id
  end

  def down
    add_column :transactions, :external_transaction_id, :integer
  end
end
