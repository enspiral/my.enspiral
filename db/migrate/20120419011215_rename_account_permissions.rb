class RenameAccountPermissions < ActiveRecord::Migration
  def up
    rename_table :account_permissions, :people_accounts
  end

  def down
    rename_table :people_accounts, :account_permissions
  end
end
