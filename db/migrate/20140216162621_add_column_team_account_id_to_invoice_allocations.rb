class AddColumnTeamAccountIdToInvoiceAllocations < ActiveRecord::Migration
  def change
  	add_column :invoice_allocations, :team_account_id, :integer
  end
end
