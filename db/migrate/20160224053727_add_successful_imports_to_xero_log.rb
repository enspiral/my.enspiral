class AddSuccessfulImportsToXeroLog < ActiveRecord::Migration
  def change
    add_column :invoices, :successful_invoices, :text, default: ""
  end
end
