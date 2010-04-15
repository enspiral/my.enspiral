class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.references :account
      t.integer :creator_id

      t.decimal :amount, :precision => 10, :scale => 2
      t.string :description
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
