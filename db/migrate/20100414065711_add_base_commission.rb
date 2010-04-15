class AddBaseCommission < ActiveRecord::Migration
  def self.up
    add_column :people, :base_commission, :decimal, :precision => 10, :scale => 2, :default => 0.2
    add_column :invoice_allocations, :commission, :decimal, :precision => 10, :scale => 2, :default => 0.2
  end

  def self.down
    remove_column :invoice_allocations, :commission
    remove_column :people, :base_commission
  end
end
