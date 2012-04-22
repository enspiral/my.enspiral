class RemoveNullFromPaid < ActiveRecord::Migration
  def up
    change_column :invoices, :paid, :boolean, null: false
  end

  def down
    change_column :invoices, :paid, :boolean, null: true
  end
end
