class AddCompanyIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :company_id, :integer
  end
end
