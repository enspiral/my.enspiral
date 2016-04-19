
module Scripts

  class AddXeroIdToInvoices

    # this script adds the Xero ID to the invoices so that we have a more dependable mechanism for keeping track of them.
    # run me first!

    def add_xero_id_to_all_invoices
      log "DATE: #{DateTime.now}"
      # invoices = Invoice.all.select{ |i| i.xero_link.match /https:\/\/go\.xero\.com\/AccountsReceivable\/View\.aspx\?InvoiceID=(.+)/ }
      invoices = Invoice.find([466, 477, 478, 479, 480, 556, 560, 562, 633, 658, 698, 710, 849, 921, 949, 969, 979, 989, 1011, 1024, 1026, 1040, 1060, 1067, 1138, 1441, 1492, 1647, 1796, 1871, 1875, 2023, 2061, 2069, 2077, 2080, 2148, 2293, 2299, 2352, 2391, 2394, 2432, 2439, 2449, 2460, 2487, 2490, 2518, 2540, 2552, 2560, 2569, 2579, 2581, 2584, 2612, 2644, 2647, 2656, 2662, 2663, 2665, 2675, 2693, 2694, 2695, 2712, 2731, 2737, 2739, 2741, 2743, 2749, 2751, 2770, 2777, 2785, 2798, 2815, 2818, 2834, 2836, 2842, 2860, 2880, 2883, 2889, 2913, 2914, 2916, 2922, 2936, 2937, 2942, 2945, 2967, 2968, 2969, 2972, 2974, 2980])
      invoices.each do |invoice|
        link = invoice.send(:attribute, :xero_link)
        begin
          match = link.match /https:\/\/go\.xero\.com\/AccountsReceivable\/View\.aspx\?InvoiceID=(.+)/
          invoice.xero_id = match[1]
          unless invoice.valid?
            begin
              log("Invoice can't save cos it has the same invoice id as #{Invoice.find_by_xero_id(match[1]).id} <==> #{invoice.id}")
            rescue
            end
          end
          invoice.save!
          log("updated id: #{invoice.id}")
        rescue => e
          log "----------------------------------------------------------------------------------------"
          log "Problem updating invoice #{invoice.id} (Xero ref #{invoice.xero_reference})."
          log "Link = #{invoice.xero_link}"
          log "Xero ID = #{match[1]}" if match
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
      @@import_logger ||= Logger.new("#{Rails.root}/log/xero_id_change.log")
    end

  end

end