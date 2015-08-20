class AddReconciledAtToExternalTransactions < ActiveRecord::Migration
  def change
    add_column :external_transactions, :reconciled_at, :datetime
  end
end
