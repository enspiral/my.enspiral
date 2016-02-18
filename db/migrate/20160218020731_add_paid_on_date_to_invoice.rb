class AddPaidOnDateToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :paid_on, :datetime
  end
end
