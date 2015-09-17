class AddExternalTransactionIdToFundsTransfers < ActiveRecord::Migration
  def change
    add_column :funds_transfers, :external_transaction_id, :integer
    add_index  :funds_transfers, :external_transaction_id
  end
end
