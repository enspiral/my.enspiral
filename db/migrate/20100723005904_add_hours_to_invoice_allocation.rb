class AddHoursToInvoiceAllocation < ActiveRecord::Migration
  def self.up
    add_column :invoice_allocations, :hours, :decimal, :precision => 10, :scale => 2, :default => 0
  end

  def self.down
    remove_column :invoice_allocations, :hours
  end
end
