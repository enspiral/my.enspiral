class RenameAccountPermissions < ActiveRecord::Migration
  def up
    unless table_exists? :people_accounts
      rename_table :account_permissions, :people_accounts
    end
  end

  def down
    rename_table :people_accounts, :account_permissions
  end
end
