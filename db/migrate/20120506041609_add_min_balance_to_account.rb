class AddMinBalanceToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :min_balance, :decimal, default: 0, null: false
  end
end
