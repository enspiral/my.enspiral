class AddCloseToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :closed, :boolean, :default => false, :null => false
  end
end
