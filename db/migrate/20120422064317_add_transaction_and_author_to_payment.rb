class AddTransactionAndAuthorToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :author_id, :integer
    add_column :payments, :transaction_id, :integer
  end
end
