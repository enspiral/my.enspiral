class AddXeroIdToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :xero_id, :string

    add_index :invoices, :xero_id
    add_index :invoices, :xero_reference
    add_index :invoices, :company_id
  end
end
