class AddInvoiceNumber < ActiveRecord::Migration
  def self.up
    add_column :invoices, :number, :integer
  end

  def self.down
    remove_column :invoices, :number
  end
end
