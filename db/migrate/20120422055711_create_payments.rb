class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments, :force => true do |t|
      t.decimal :amount, :precision => 10, :scale => 2
      t.date :paid_on
      t.integer :invoice_id
      t.timestamps
    end
  end
end
