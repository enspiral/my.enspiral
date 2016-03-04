class OopsWrongTable < ActiveRecord::Migration
  def up
    remove_column(:invoices, :successful_invoices)
    add_column(:xero_import_logs, :successful_invoices, :text, {:default=>""})
  end

  def down
    remove_column(:xero_import_logs, :successful_invoices)
    add_column(:invoices, :successful_invoices, :text, {:default=>""})
  end
end
