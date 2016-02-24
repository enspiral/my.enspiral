module Loggers
  class ImportLogger

    def self.import_logger
      @@import_logger ||= Logger.new("#{Rails.root}/log/xero_import.log", 10, 100.megabytes)
    end

  end

  def log_results(result)
    log "#{Time.now} #{result[:count]} invoices attempted. #{result[:errors].keys.count} had errors!"
    log "Successfully imported #{result[:successful].map(&:xero_reference).join(", ")}"
    result[:errors].each do |xero_id,error|
      log "#{xero_id} --- #{error.class.name} : #{error.message}"
    end
  end

  def save_to_db(result, company, author = nil)
    error_entries = []
    result[:errors].each do |xero_id,error|
      error_entries << "#{xero_id} --- #{error.class.name} : #{error.message}"
    end
    error_result = {}
    result[:errors].each do |xero_id, error|
      error_result[xero_id] = "#{error.class.name} : #{error.message}"
    end

    successful_invoices = result[:successful].map(&:xero_reference)

    save_import_results_to_db(result[:count], successful_invoices, error_result, company)
  end

  def save_import_results_to_db(total_invoices, successful_invoices, invoices_with_errors, company, author=nil)
    # invoices_with_errors should be in the format: {INV-xxxx => "Error message"} or {XERO_ID => "Error_message"}
    XeroImportLog.create(performed_at: company.time_in_zone(Time.zone.now), person: author, company: company,
                         number_of_invoices: total_invoices, successful_invoices: successful_invoices, invoices_with_errors: invoices_with_errors)
  end

  def log(message)
    ::Loggers::ImportLogger.import_logger.info(message)
  end

end