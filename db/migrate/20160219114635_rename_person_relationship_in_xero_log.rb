class RenamePersonRelationshipInXeroLog < ActiveRecord::Migration
  def up
    rename_column :xero_import_logs, :performed_by, :person
  end

  def down
    rename_column :xero_import_logs, :person, :performed_by
  end
end
