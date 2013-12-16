class AddApprovedToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :approved, :boolean, :default => true
  end
end
