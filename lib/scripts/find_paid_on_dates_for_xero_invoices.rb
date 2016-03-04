module Scripts

  class FindPaidOnDatesForXeroInvoices

    def fill_in_paid_on_dates
      company = Company.find(1)
      xero_invoices = company.xero.Invoice.all(where: 'Status=="PAID"&&type=="ACCREC"')

      xero_invoices.each do |xero_invoice|
        begin
          enspiral_invoices = Invoice.where(company_id: 1, xero_id: xero_invoice.invoice_id)
          unless enspiral_invoices.present?
            enspiral_invoices = Invoice.where(company_id: 1, xero_reference: remove_inv_prefix(xero_invoice.invoice_number))
          end

          raise "Multiple instances of this invoice reference!" if enspiral_invoices.count > 1
          enspiral_invoice = enspiral_invoices.first

          if enspiral_invoice.present?
            enspiral_invoice.xero_reference = xero_invoice.invoice_number
            enspiral_invoice.paid_on = xero_invoice.fully_paid_on_date if enspiral_invoice.company
            enspiral_invoice.line_amount_types = xero_invoice.line_amount_types
            enspiral_invoice.xero_id = xero_invoice.invoice_id
            enspiral_invoice.total = xero_invoice.total
            enspiral_invoice.save!
          end
        rescue => e
          log "----------------------------------------------------------------------------------------"
          log "Problem updating enspiral invoice id= #{enspiral_invoice.id}" if enspiral_invoice
          log "Xero Invoice = #{xero_invoice.invoice_id}"
          log "Error: #{e.message}"
        end
      end

      puts "done!"
    end

    def log(message)
      ::Scripts::ImportLogger.import_logger.info(message)
    end

    def remove_inv_prefix(invoice_number)
      match = invoice_number.match(/INV-(\d+)/)
      return match[1] if match
      nil
    end
  end

  class ImportLogger

    def self.import_logger
      @@import_logger ||= Logger.new("#{Rails.root}/log/xero_paid_dates.log")
    end

  end

end

#<Xeroizer::Record::Invoice :contact:
# #<Xeroizer::Record::Contact :contact_id: "d1bb36ec-ce7e-4642-a314-e0e3bcb98d9b", :contact_status: "ACTIVE", :name: "Enspiral Dev Academy",
# :first_name: "Malcolm", :last_name: "Shearer", :email_address: "accounts@devacademy.co.nz",
# :addresses: [#<Xeroizer::Record::Address :address_type: "POBOX", :address_line1: "L2, 15 Walter Street", :address_line2: "Te Aro",
# :address_line3: "Wellington 6011", :address_line4: "NEW ZEALAND", :attention_to: "Rohan Wakefield">, #<Xeroizer::Record::Address :address_type: "STREET">],
# :phones: [#<Xeroizer::Record::Phone :phone_type: "DDI">, #<Xeroizer::Record::Phone :phone_type: "FAX">, #<Xeroizer::Record::Phone :phone_type: "DEFAULT">,
# #<Xeroizer::Record::Phone :phone_type: "MOBILE">],
# :updated_date_utc: 2014-10-05 23:21:16 UTC, :is_supplier: true, :is_customer: true, :default_currency: "NZD">,
#
# :date: Wed, 03 Feb 2016, :due_date: Sat, 13 Feb 2016, :branding_theme_id: "b8d4c77a-3802-481e-81b0-23caa6fb7176", :status: "PAID",
# :line_amount_types: "Exclusive", :line_items: [#<Xeroizer::Record::LineItem :description: "Joshua Vial wages",
# :unit_amount: #<BigDecimal:ed20344,'0.2308E4',9(18)>, :tax_type: "OUTPUT2", :tax_amount: #<BigDecimal:ed1f3a4,'0.3462E3',18(18)>,
# :line_amount: #<BigDecimal:ed1ebfc,'0.2308E4',9(18)>, :account_code: "201", :tracking: [#<Xeroizer::Record::TrackingCategoryChild :name: "Team",
# :option: "Craftworks", :tracking_category_id: "332405f3-1fbe-43a5-b60c-9e23cc485b78">, #<Xeroizer::Record::TrackingCategoryChild :name: "Allocation",
# :option: "Joshua Vial-05", :tracking_category_id: "1378cb31-2cf6-4232-aa92-1ae9ddeae52d">], :quantity: #<BigDecimal:ed2e818,'0.1E1',9(18)>,
# :line_item_id: "4f6d91ab-1dab-4806-b3db-4e655413073a">, #<Xeroizer::Record::LineItem :description: "Malcolm Shearer wages",
# :unit_amount: #<BigDecimal:ed41224,'0.1346E4',9(18)>, :tax_type: "OUTPUT2", :tax_amount: #<BigDecimal:ed4020c,'0.2019E3',18(18)>,
# :line_amount: #<BigDecimal:ed3f938,'0.1346E4',9(18)>, :account_code: "201",
# :tracking: [#<Xeroizer::Record::TrackingCategoryChild :name: "Team", :option: "Operations", :tracking_category_id: "332405f3-1fbe-43a5-b60c-9e23cc485b78">,
# #<Xeroizer::Record::TrackingCategoryChild :name: "Allocation", :option: "Malcolm Shearer-05", :tracking_category_id: "1378cb31-2cf6-4232-aa92-1ae9ddeae52d">],
# :quantity: #<BigDecimal:ed4e4d8,'0.1E1',9(18)>, :line_item_id: "39a761ed-1179-4cee-ae18-17f86326a620">,
# #<Xeroizer::Record::LineItem :description: "Rebeka Whale wages", :unit_amount: #<BigDecimal:ed60930,'0.1191E4',9(18)>,
# :tax_type: "OUTPUT2", :tax_amount: #<BigDecimal:ed5f83c,'0.17865E3',18(18)>, :line_amount: #<BigDecimal:ed5efb8,'0.1191E4',9(18)>,
# :account_code: "201", :tracking: [#<Xeroizer::Record::TrackingCategoryChild :name: "Team", :option: "Iguanas",
# :tracking_category_id: "332405f3-1fbe-43a5-b60c-9e23cc485b78">, #<Xeroizer::Record::TrackingCategoryChild :name: "Allocation", :option: "Rebeka Whale-05",
# :tracking_category_id: "1378cb31-2cf6-4232-aa92-1ae9ddeae52d">], :quantity: #<BigDecimal:ed6e580,'0.1E1',9(18)>,
# :line_item_id: "a9a03095-b918-4829-a2e5-3ad7d432b91e">, #<Xeroizer::Record::LineItem :description: "Michael Smith wages",
# :unit_amount: #<BigDecimal:ed812e8,'0.1423E4',9(18)>, :tax_type: "OUTPUT2", :tax_amount: #<BigDecimal:ed80758,'0.21345E3',18(18)>,
# :line_amount: #<BigDecimal:ed7ffb0,'0.1423E4',9(18)>, :account_code: "201",
# :tracking: [#<Xeroizer::Record::TrackingCategoryChild :name: "Team", :option: "Iguanas", :tracking_category_id: "332405f3-1fbe-43a5-b60c-9e23cc485b78">,
# #<Xeroizer::Record::TrackingCategoryChild :name: "Allocation", :option: "Michael Smith-05", :tracking_category_id: "1378cb31-2cf6-4232-aa92-1ae9ddeae52d">],
# :quantity: #<BigDecimal:ed8e894,'0.1E1',9(18)>, :line_item_id: "9a7c7ebe-1336-4695-b096-2fa43c564111">,
# #<Xeroizer::Record::LineItem :description: "Dan Lewis wages", :unit_amount: #<BigDecimal:eda0b0c,'0.2084E4',9(18)>, :tax_type: "OUTPUT2",
# :tax_amount: #<BigDecimal:ed9fd10,'0.3126E3',18(18)>, :line_amount: #<BigDecimal:ed9f5f4,'0.2084E4',9(18)>, :account_code: "201",
# :tracking: [#<Xeroizer::Record::TrackingCategoryChild :name: "Team", :option: "Iguanas", :tracking_category_id: "332405f3-1fbe-43a5-b60c-9e23cc485b78">,
# #<Xeroizer::Record::TrackingCategoryChild :name: "Allocation", :option: "Daniel Lewis-05", :tracking_category_id: "1378cb31-2cf6-4232-aa92-1ae9ddeae52d">],
# :quantity: #<BigDecimal:edae6f8,'0.1E1',9(18)>, :line_item_id: "27b3d019-1e39-4822-b635-c41daa409dad">], :sub_total: #<BigDecimal:edc0e98,'0.8352E4',9(18)>,
# :total_tax: #<BigDecimal:edc0510,'0.12528E4',18(18)>, :total: #<BigDecimal:edbfe30,'0.96048E4',18(18)>, :updated_date_utc: 2016-02-10 23:18:36 UTC,
# :currency_code: "NZD", :fully_paid_on_date: 2016-02-10 00:00:00 +1300, :type: "ACCREC", :invoice_id: "9a3e52c2-b3fc-43a9-973f-155081afbfc3",
# :invoice_number: "INV-3365", :reference: "Staff payments", :payments: [#<Xeroizer::Record::Payment :payment_id: "07d2d437-be71-4db0-95f0-a935ecfb9acf",
# :date: Wed, 10 Feb 2016, :amount: #<BigDecimal:ede1a58,'0.96048E4',18(18)>, :currency_rate: #<BigDecimal:ede1440,'0.1E1',9(18)>>],
# :amount_due: #<BigDecimal:ede0b80,'0.0',9(18)>, :amount_paid: #<BigDecimal:ede04b4,'0.96048E4',18(18)>, :sent_to_contact: true,
# :currency_rate: #<BigDecimal:eddf370,'0.1E1',9(18)>, :has_attachments: false>
