class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.references :customer
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :currency
      t.boolean :paid
      t.date :date
      t.date :due

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
