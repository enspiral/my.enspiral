class AddReversalOfToFundsTransfer < ActiveRecord::Migration
  def change
    add_column :funds_transfers, :reversal, :integer
  end
end
