
module Scripts

  class FindDuplicateInvoices

    def get_duplicate_invoices
      c = Company.enspiral_services

      all_invoices = c.invoices

      new_invoices = c.invoices.where("created_at >= :end_date", {end_date: DateTime.new(2016, 03, 04)})

      duplicate_invoices = {}
      new_invoices.each do |invoice|
        # DELETE IF IT HAS NOT BEEN MODIFIED
        # AND NO PAYMENTS
        # AND NO MODIFIED ALLOCATIONS

        # next if invoice.xero_reference.match(/INV-(\d+)/) == nil
        # duplicates = all_invoices.select{|i| remove_inv_prefix(i.xero_reference) == invoice.xero_reference}
        # if duplicates.any?
          # puts "duplicate of id: #{invoice.id} - xero ref #{invoice.xero_reference}: #{duplicate}"
          # duplicate_invoices[invoice] = duplicates
        # end
      end

      # duplicate_invoices
    end
    
    def check_duplicate_invoices
      [{old: 3013, new: 2974}, {old: 3011, new: 2972}, {old: 3009, new: 2969}, {old: 3008, new: 2968}, {old: 3007, new: 2967}, {old: 2993, new: 2945},
      {old: 2991, new: 2942}, {old: 3015, new: 2937}, {old: 2988, new: 2936}, {old: 2986, new: 2916}, {old: 2985, new: 2914}, {old: 2984, new: 2913}, 
      {old: 2983, new: 2889}, {old: 3021, new: 2980}, {old: 3007, new: 2967}, {old: 2990, new: 2922}, {old: 2692, new: 2647}].each do |hash|
        hash[:old]
      end
    end

    def mod_unmod
      c = Company.enspiral_services
      new_invoices = c.invoices.where("created_at >= :end_date", {end_date: DateTime.new(2016, 03, 04)}).includes(:payments)

      invoices = []
      invoices_with_old = []

      new_invoices.each do |inv|
        hash = {}
        hash[:new_invoice] = inv
        if modified_since_creation?(inv)
          hash[:new_invoice_changed] = modified_since_creation?(inv)
        end
        hash[:old_invoice] = Invoice.where(xero_reference: remove_inv_prefix(inv.xero_reference))
        invoices_with_old << "#{inv.id} (new) => #{hash[:old_invoice].first.id}" if hash[:old_invoice].any?
        invoices << hash
      end
      invoices_with_old
    end

    def modified_since_creation?(invoice)
      return "updated since creation" unless unmodified?(invoice)
      return "has #{invoice.payments.count} payments" if invoice.payments.any?
      invoice.allocations.each do |allocation|
        return "one or more allocations modified" if unmodified?(allocation)
      end
      false
    end

    def unmodified?(obj)
      same_time?(obj.updated_at, obj.created_at)
    end

    def same_time?(time1, time2)
      round_time(time1) == round_time(time2)
    end

    def round_time(time)
      time.change(:min => 0)
    end

    def log(message)
     ::Scripts::ImportLogger.import_logger.info(message)
    end

    def remove_inv_prefix(invoice_number)
      match = invoice_number.match(/INV-(\d+)/)
      return match[1] if match
    # rescue
      nil
    end
  end

  class ImportLogger

    def self.import_logger
      @@import_logger ||= Logger.new("#{Rails.root}/log/xero_duplicates.log")
    end

  end

end