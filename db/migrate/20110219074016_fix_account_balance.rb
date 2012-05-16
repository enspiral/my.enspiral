class FixAccountBalance < ActiveRecord::Migration
  def self.up
    change_column :accounts, :balance, :decimal, :precision => 10, :scale => 2, :default => 0
  end

  def self.down
    change_column :accounts, :balance, :integer, :default => 0
  end
end
