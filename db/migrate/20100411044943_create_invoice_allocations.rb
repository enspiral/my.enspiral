class CreateInvoiceAllocations < ActiveRecord::Migration
  def self.up
    create_table :invoice_allocations do |t|
      t.references :person
      t.references :invoice
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :currency
      t.boolean :disbursed

      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_allocations
  end
end
