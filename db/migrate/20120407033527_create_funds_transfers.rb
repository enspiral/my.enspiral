class CreateFundsTransfers < ActiveRecord::Migration
  def change
    create_table :funds_transfers, :force => true do |t|
      t.integer :author_id
      t.decimal :amount
      t.integer :source_account_id
      t.integer :destination_account_id
      t.integer :source_transaction_id
      t.integer :destination_transaction_id
      t.string :description

      t.timestamps
    end
  end
end
