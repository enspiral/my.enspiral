class MoveAssociationFromFundsTransferToExternalTransaction < ActiveRecord::Migration
  def up
    remove_column :funds_transfers, :external_transaction_id
    add_column    :external_transactions, :funds_transfer_id, :integer
  end

  def down
  end
end
