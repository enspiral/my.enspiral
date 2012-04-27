class ChangeInvoiceAllocationsDisbursedToNotNull < ActiveRecord::Migration
  def change
    InvoiceAllocation.all.each do |ia|
      ia.update_attribute(:disbursed, false) if ia.disbursed.nil?
    end
    change_column :invoice_allocations, :disbursed, :boolean, null: false, default: false
  end
end
