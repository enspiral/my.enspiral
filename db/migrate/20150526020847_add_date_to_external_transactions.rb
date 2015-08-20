class AddDateToExternalTransactions < ActiveRecord::Migration
  def change
    add_column :external_transactions, :date, :datetime
  end
end
