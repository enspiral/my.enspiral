class MakeFalseDefaultForPaidOnInvoices < ActiveRecord::Migration
  def up
    change_column :invoices, :paid, :boolean, :null => false, :default => false
  end

  def down
    change_column :invoices, :paid, :boolean, :null => false
  end
end
