class AddDisbursedToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :disbursed, :boolean, null: false, default: false
  end
end
