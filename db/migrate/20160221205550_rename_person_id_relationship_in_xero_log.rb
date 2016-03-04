class RenamePersonIdRelationshipInXeroLog < ActiveRecord::Migration
  def up
    rename_column :xero_import_logs, :person, :person_id
  end

  def down
    rename_column :xero_import_logs, :person_id, :person
  end
end
