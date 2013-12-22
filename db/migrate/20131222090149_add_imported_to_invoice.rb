class AddImportedToInvoice < ActiveRecord::Migration
  def change
  	add_column :invoices, :imported, :boolean, :default => false
  end
end
