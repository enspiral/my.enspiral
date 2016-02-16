module Loggers
  class ImportLogger

    def self.import_logger
      @@import_logger ||= Logger.new("#{Rails.root}/log/xero_import.log", 10, 100.megabytes)
    end

  end

  def log_results(result)
    log "#{Time.now} #{result[:count]} invoices attempted. #{result[:errors].keys.count} had errors!"
    result[:errors].each do |xero_id,error|
      log "#{xero_id} --- #{error.class.name} : #{error.message}"
    end
  end

  def save_to_db(result, author = nil)
    time = Time.zone.now
    company_id = Company.find_by_name("#{APP_CONFIG[:organization_full]}").id
    log_entry = XeroImportLog.new(performed_at: time, author: author, company_id: company_id, number_of_errors: result[:errors].keys.count,
                                    number_of_invoices: result[:count])

    error_entries = []
    result[:errors].each do |xero_id,error|
      error_entries << "#{xero_id} --- #{error.class.name} : #{error.message}"
    end
    log_entry.invoices_with_errors = error_entries.join(", ")
    log_entry.save
  end

  def log(message)
    ::Loggers::ImportLogger.import_logger.info(message)
  end

end