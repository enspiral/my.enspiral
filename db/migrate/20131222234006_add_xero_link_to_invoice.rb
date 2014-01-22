class AddXeroLinkToInvoice < ActiveRecord::Migration
  def change
  	add_column :invoices, :xero_link, :string, :default => "#"
  end
end
