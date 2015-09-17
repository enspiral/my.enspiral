class CreateExternalTransactions < ActiveRecord::Migration
  def change
    create_table    :external_transactions do |t|
      t.integer     :external_id
      t.decimal     :amount, precision: 10, scale: 2
      t.belongs_to  :external_account, index: true
      t.belongs_to  :person, index: true
      t.string      :description

      t.timestamps
    end

    add_column :transactions, :external_transaction_id, :integer
  end
end
