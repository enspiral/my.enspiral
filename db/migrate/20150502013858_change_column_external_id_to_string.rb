class ChangeColumnExternalIdToString < ActiveRecord::Migration
  def up
    change_column :external_transactions, :external_id,  :string
  end

  def down
    change_column :external_transactions, :external_id,  :string
  end
end
