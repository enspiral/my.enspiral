class RemoveNumberOfErrorsFromXeroImportLog < ActiveRecord::Migration
  def up
    remove_column :xero_import_logs, :number_of_errors
  end

  def down
    add_column :xero_import_logs, :number_of_errors, :integer
  end
end
