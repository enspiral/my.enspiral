
module Scripts

  class AddXeroIdToInvoices

    # this script adds the Xero ID to the invoices so that we have a more dependable mechanism for keeping track of them.
    # run me first!

    def add_xero_id_to_all_invoices
      invoices = Invoice.all.select{ |i| i.xero_link.match /https:\/\/go\.xero\.com\/AccountsReceivable\/View\.aspx\?InvoiceID=(.+)/ }
      invoices.each do |invoice|
        match = invoice.xero_link.match /https:\/\/go\.xero\.com\/AccountsReceivable\/View\.aspx\?InvoiceID=(.+)/
        begin
          invoice.update_attribute(:xero_id, match[1])
        rescue => e
          log "----------------------------------------------------------------------------------------"
          log "Problem updating invoice #{invoice.id} (Xero ref #{invoice.xero_reference})."
          log "Link = #{invoice.xero_link}"
          log "Xero ID = #{match[1]}"
          log "Error: #{e.message}"
        end
      end
      puts "done!"
    end

    def log(message)
     ::Scripts::ImportLogger.import_logger.info(message)
    end
  end

  class ImportLogger

    def self.import_logger
      @@import_logger ||= Logger.new("#{Rails.root}/log/xero_id.log")
    end

  end

end