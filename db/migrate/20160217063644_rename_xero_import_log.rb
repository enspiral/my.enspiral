class RenameXeroImportLog < ActiveRecord::Migration
  def up
    rename_table :xero_import_log, :xero_import_logs
  end

  def down
    rename_table :xero_import_logs, :xero_import_log
  end
end
