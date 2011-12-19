class InvoiceAllocationAccount < ActiveRecord::Migration
  def up
    add_column :invoice_allocations, :account_id, :integer
    InvoiceAllocation.all.each do |allocation|
      allocation.update_attribute(:account_id, allocation.person.account.id) if allocation.person.present?
    end
  end

  def down
    remove_column :invoice_allocations, :account_id
  end
end
