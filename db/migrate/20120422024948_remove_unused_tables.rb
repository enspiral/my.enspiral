class RemoveUnusedTables < ActiveRecord::Migration
  def up
    drop_table :goals if table_exists? :goals
    drop_table :account_permissions if table_exists? :account_permissions
    drop_table :comments if table_exists? :comments
    drop_table :notices if table_exists? :notices
  end

  def down
  end
end
