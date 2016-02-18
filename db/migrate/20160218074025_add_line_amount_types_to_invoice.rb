class AddLineAmountTypesToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :line_amount_types, :string
  end
end
