class AddUniquenessIndexToXeroId < ActiveRecord::Migration
  def change
    remove_index :invoices, :xero_id
    add_index :invoices, :xero_id, unique: true
  end
end
