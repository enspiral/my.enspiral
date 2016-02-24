class RemoveDefaultFromXeroImportLogSuccessfulImports < ActiveRecord::Migration
  def up
    change_column_default :xero_import_logs, :successful_invoices, nil
    XeroImportLog.all.each do |log|
      log.successful_invoices = nil if log.successful_invoices.blank?
    end
  end

  def down
    change_column_default :xero_import_logs, :successful_invoices, ""
  end
end
