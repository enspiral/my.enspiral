class AddFieldsToFundsTransfer < ActiveRecord::Migration

  def up
    add_column :funds_transfers, :reconciled, :boolean
    add_column :funds_transfers, :date, :date

    FundsTransfer.all.each do |ft|
      ft.update_attribute(:date,ft.source_transaction.date)
    end
  end

  def down
    remove_column :funds_transfers, :reconciled
    remove_column :funds_transfers, :date
  end
end
