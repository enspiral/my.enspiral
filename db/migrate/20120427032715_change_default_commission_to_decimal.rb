class ChangeDefaultCommissionToDecimal < ActiveRecord::Migration
  def change
    change_column :companies, :default_commission, :decimal, :precision => 10, :scale => 2, :default => 0.2
  end
end
