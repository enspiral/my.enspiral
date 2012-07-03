class ChangeCommissionToContribution < ActiveRecord::Migration
  def change
    rename_column :invoice_allocations, :commission, :contribution
    rename_column :companies, :default_commission, :default_contribution
  end
end
