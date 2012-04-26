class AddCompanyComissionToInvoiceAllocations < ActiveRecord::Migration
  def change
    add_column :invoice_allocations, :company_commission, :integer
  end
end
