class ChangeColumnContributionInTableInvoiceAllocation < ActiveRecord::Migration
  def up
  	change_column :invoice_allocations, :contribution, :decimal, :precision => 10, :scale => 3, :default => 0.20
  end

  def down
  	change_column :invoice_allocations, :contribution, :decimal, :precision => 10, :scale => 2, :default => 0.2
  end
end
