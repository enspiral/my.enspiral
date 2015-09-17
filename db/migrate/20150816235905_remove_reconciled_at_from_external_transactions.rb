class RemoveReconciledAtFromExternalTransactions < ActiveRecord::Migration
  def up
    remove_column :external_transactions, :reconciled_at
  end

  def down
  end
end
