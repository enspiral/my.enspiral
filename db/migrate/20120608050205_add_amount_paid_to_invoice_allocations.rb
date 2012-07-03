class AddAmountPaidToInvoiceAllocations < ActiveRecord::Migration
  def up
    add_column :payments, :invoice_allocation_id, :integer
    add_column :payments, :new_cash_transaction_id, :integer
    add_column :payments, :renumeration_funds_transfer_id, :integer
    add_column :payments, :contribution_funds_transfer_id, :integer

    #remove_column :invoices, :disbursed
    #remove_column :invoice_allocations, :disbursed
    remove_column :invoice_allocations, :company_commission
  end

  def down
    add_column :invoice_allocations, :company_commission, :integer
    #add_column :invoice_allocations, :disbursed, :boolean
    #add_column :invoices, :disbursed, :boolean

    remove_column :payments, :contribution_funds_transfer_id
    remove_column :payments, :renumeration_funds_transfer_id
    remove_column :payments, :new_cash_transaction_id
    remove_column :payments, :invoice_allocation_id
  end
end
