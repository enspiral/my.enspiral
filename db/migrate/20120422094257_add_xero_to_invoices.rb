class AddXeroToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :xero_reference, :string
  end
end
