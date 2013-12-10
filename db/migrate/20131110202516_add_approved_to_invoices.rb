class AddApprovedToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :approved, :boolean, :default => true
  end
end
