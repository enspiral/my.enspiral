require 'xero_errors'
require 'loggers/import_logger'

module XeroImport
  include XeroErrors
  include Loggers

  # this code is being refactored from existing code which is in dire need of cleanup
  # it's not mine! git blame lies! #buckpass
  # -c

  def check_discount_value_in_line_item inv
    inv.line_items.each do |el|
      return true if el.attributes[:line_amount] < 0
    end
    false
  end

  def import_discount_line_items inv, saved_invoice
    allocation_personal_with_discount = ""
    allocation_amount_with_discount = 0
    total_positive_line_item = 0
    allocation_amount = 0
    allocation_account = ""
    allocation_contribution = 0
    allocation_team_account = ""
    total_line_item_with_discount = 0
    allocation_currency = ""
    inv.line_items.each do |el|
      if el.attributes[:line_amount] < 0
        allocation_personal_with_discount = el.tracking[1].option
        allocation_amount_with_discount = el.attributes[:line_amount]
      end
    end

    inv.line_items.each do |el|
      if el.tracking[1].option == allocation_personal_with_discount && el.attributes[:line_amount] > 0
        total_positive_line_item = total_positive_line_item + el.attributes[:line_amount]
      end
    end
    total_line_item_with_discount = total_positive_line_item + allocation_amount_with_discount

    inv.line_items.each do |el|
      allocation_team = el.tracking[0].option
      allocation_personal = el.tracking[1].option
      allocation = allocation_personal.split("-")
      allocation_currency = inv.currency_code
      if el.tracking[1].option == allocation_personal_with_discount && el.attributes[:line_amount] > 0
        line_percentage = el.attributes[:line_amount] / total_positive_line_item
        line_discount_value = line_percentage * allocation_amount_with_discount
        allocation_amount = el.attributes[:line_amount] + line_discount_value
      end
      if Account.find_by_name("#{allocation[0]}'s Enspiral Account")
        allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral Account")
      elsif Account.find_by_name("#{allocation[0]}'s Enspiral account")
        allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral account")
      elsif Account.find_by_name("#{allocation[0]}'s Enspiral Services account")
        allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral Services account")
      elsif Account.find_by_name("#{allocation[0]}")
        allocation_account = Account.find_by_name("#{allocation[0]}")
      end
      allocation_team_account = Account.find_by_name("TEAM: #{allocation_team}")
      allocation_contribution = allocation[1].to_i / 100.0
      if el.attributes[:line_amount] > 0 && allocation_amount && allocation_account && allocation_account.closed == false && allocation_contribution && allocation_team_account
        if allocation_amount > 0
          InvoiceAllocation.create!(:invoice_id => saved_invoice.id,
                                    :amount => allocation_amount,
                                    :currency => allocation_currency,
                                    :contribution => allocation_contribution,
                                    :account_id => allocation_account.id,
                                    :team_account_id => allocation_team_account.id)
        else
          inv_allocation = InvoiceAllocation.where(:invoice_id => saved_invoice.id,
                                                   :account_id => allocation_account.id,
                                                   :team_account_id => allocation_team_account.id)

          if inv_allocation.count > 0
            inv_allocation[0].amount = inv_allocation[0].amount + allocation_amount
            inv_allocation[0].save!
          end
        end
      end
    end
  end

  def import_line_items inv, saved_invoice
    inv.line_items.each do |el|
      if el.tracking.count == 1 && el.tracking[0].name == "Team"
        allocation_team = el.tracking[0].option
        allocation_personal = el.tracking[0].option
        allocation_currency = inv.currency_code
        # if el.attributes[:tax_amount]
        #   allocation_amount = el.attributes[:line_amount] - el.attributes[:tax_amount]
        # else
        allocation_amount = el.attributes[:line_amount]
        # end
        allocation_account = Account.find_by_name("TEAM: #{allocation_team}")
        allocation_team_account = Account.find_by_name("TEAM: #{allocation_team}")
        allocation_contribution = 0.20
      elsif el.tracking.count == 2
        allocation_team = el.tracking[0].option
        allocation_personal = el.tracking[1].option
        allocation = allocation_personal.split("-")
        allocation_currency = inv.currency_code
        # if el.attributes[:tax_amount]
        #   allocation_amount = el.attributes[:line_amount] - el.attributes[:tax_amount]
        # else
        allocation_amount = el.attributes[:line_amount]
        # end
        if Account.find_by_name("#{allocation[0]}'s Enspiral Account")
          allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral Account")
        elsif Account.find_by_name("#{allocation[0]}'s Enspiral account")
          allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral account")
        elsif Account.find_by_name("#{allocation[0]}'s Enspiral Services account")
          allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral Services account")
        elsif Account.find_by_name("#{allocation[0]}")
          allocation_account = Account.find_by_name("#{allocation[0]}")
        end
        allocation_team_account = Account.find_by_name("TEAM: #{allocation_team}")
        allocation_contribution = allocation[1].to_i / 100.0
      end
      if allocation_amount && allocation_account && allocation_account.closed == false && allocation_contribution && allocation_team_account
        if allocation_amount > 0
          InvoiceAllocation.create!(:invoice_id => saved_invoice.id,
                                    :amount => allocation_amount,
                                    :currency => allocation_currency,
                                    :contribution => allocation_contribution,
                                    :account_id => allocation_account.id,
                                    :team_account_id => allocation_team_account.id)
        else
          inv_allocation = InvoiceAllocation.where(:invoice_id => saved_invoice.id,
                                                   :account_id => allocation_account.id,
                                                   :team_account_id => allocation_team_account.id)

          if inv_allocation.count > 0
            inv_allocation[0].amount = inv_allocation[0].amount + allocation_amount
            inv_allocation[0].save!
          end
        end
      end
    end
  end

  def find_fault_subtotal invoices
    fault_invoices = []
    invoices.each do |xero_invoice|
      enspiral_invoice = Invoice.find_by_xero_id(xero_invoice.invoice_id)
      if enspiral_invoice && enspiral_invoice.amount != xero_invoice.sub_total
        fault_invoices << xero_invoice.invoice_number
        # enspiral_invoice.amount = inv.attributes[:sub_total]
        # enspiral_invoice.save!
      end
    end
    fault_invoices
  end

  def update_all_existing_invoice xero_invoices
    invoices_count = 0
    import_result = {}
    import_result[:errors] = {}
    puts "Importing (and updating) #{xero_invoices.count} invoices..."
    xero_invoices.each do |xero_invoice|
      invoices_count += 1
      try_to_hit_xero(import_result, xero_invoice) do
        update_existing_invoice xero_invoice
      end
    end
    import_result[:count] = invoices_count
    import_result
  end

  def update_existing_invoice xero_invoice, incoming_invoice=nil
    enspiral_invoice = incoming_invoice || Invoice.find_by_xero_id(xero_invoice.invoice_id)
    throw_cannot_find_invoice_error(xero_invoice) unless enspiral_invoice
    if xero_invoice.status == "VOIDED"
      enspiral_invoice.destroy
      throw_invalid_xero_status_error(xero_invoice)
    end
    throw_already_paid_error if enspiral_invoice.paid

    customer = Customer.find_by_name(xero_invoice.contact.name)
    unless customer
      customer = Customer.new(name: xero_invoice.contact.name, company_id: enspiral_invoice.company_id, approved: false)
      customer.save
    end

    throw_invalid_customer_error(customer) unless customer.valid?
    enspiral_invoice.customer = customer if customer

    enspiral_invoice.amount = xero_invoice.sub_total
    enspiral_invoice.xero_id = xero_invoice.invoice_id
    enspiral_invoice.paid_on = xero_invoice.fully_paid_on_date
    enspiral_invoice.date = xero_invoice.date
    enspiral_invoice.due = xero_invoice.due_date
    enspiral_invoice.total = xero_invoice.total
    enspiral_invoice.line_amount_types = xero_invoice.line_amount_types
    enspiral_invoice.currency = xero_invoice.currency_code
    enspiral_invoice.xero_reference = xero_invoice.invoice_number

    if enspiral_invoice.allocations.count > 0
      enspiral_invoice.allocations.destroy_all
    end

    if xero_invoice.line_items.count > 0
      # Invoice.check_discount_value_in_line_item inv, enspiral_invoice
      Invoice.import_line_items xero_invoice, enspiral_invoice
    end

    enspiral_invoice.save!
    enspiral_invoice
  end

  def import_invoices_from_xero xero_invoices, company=nil
    import_result = {}
    import_result[:errors] = {}
    invoices_count = 0
    company_id = company.id
    successful = []
    puts "Importing #{xero_invoices.count} invoices from Xero..."
    xero_invoices.each do |xero_invoice|
      invoices_count += 1
      puts "#{invoices_count} - #{xero_invoice.invoice_number}"
      try_to_hit_xero(import_result, xero_invoice) do
        new_invoice = insert_single_invoice(xero_invoice, company_id)
        successful << new_invoice if new_invoice
      end
    end
    import_result[:successful] = successful

    if Invoice.where(imported: true).count > 1
      xero_invoices = Invoice.where(imported: true)
      xero_invoices.each_with_index do |inv, i|
        if i > 1
          inv.imported = false
          inv.save
        end
      end
    end
    import_result
  end

  def try_to_hit_xero(import_result, xero_invoice)
    tries = 0
    begin
      yield
    rescue Xeroizer::OAuth::RateLimitExceeded => e
      tries += 1
      if tries <= 3
        puts "Rate limit exceeded! Trying again in 20 seconds... (try # #{tries})"
        sleep 20
        retry
      else
        puts "Giving up - try again tomorrow?"
        import_result[:errors][xero_invoice.invoice_id] = e
      end
    rescue => other_error
      import_result[:errors][xero_invoice.invoice_id] = other_error
    end
  end

  def insert_single_invoice xero_invoice, c_id=nil
    throw_invalid_xero_status_error(xero_invoice) unless xero_invoice.status == "AUTHORISED" || xero_invoice.status == "PAID"

    company_id = c_id || Company.enspiral_services.id

    customer = Customer.find_by_name(xero_invoice.contact.name)
    unless customer
      customer = Customer.new(name: xero_invoice.contact.name, company_id: company_id, approved: false)
      customer.save
    end

    throw_invalid_customer_error(customer) unless customer && customer.valid?

    new_invoice = Invoice.new(customer_id: customer.id, amount: xero_invoice.sub_total, date: xero_invoice.date, due: xero_invoice.due_date,
                              xero_reference: xero_invoice.invoice_number, company_id: company_id, approved: false, total: xero_invoice.total,
                              currency: xero_invoice.currency_code, imported: false, xero_id: xero_invoice.invoice_id, line_amount_types: xero_invoice.line_amount_types)

    return nil if new_invoice.invalid? && (new_invoice.errors[:xero_id] =~ /already been taken/ || new_invoice.errors[:xero_reference] =~ /already been taken/)

    new_invoice.save!
    if xero_invoice.line_items.count > 0
      discount_existed = Invoice.check_discount_value_in_line_item xero_invoice
      if discount_existed
        Invoice.import_discount_line_items xero_invoice, new_invoice
      else
        Invoice.import_line_items xero_invoice, new_invoice
      end
    end
    new_invoice
  end

  def throw_cannot_find_invoice_error(xero_invoice)
    raise XeroErrors::CannotFindEnspiralInvoiceError.new("Cannot find imported copy of invoice #{xero_invoice.invoice_number} (#{xero_invoice.invoice_id})")
  end

  def throw_invalid_customer_error(customer)
    raise XeroErrors::InvalidCustomerError.new("New customer from Xero is invalid: (#{customer.errors.messages.to_s})")
  end

  def throw_already_paid_error
    raise XeroErrors::EnspiralInvoiceAlreadyPaidError.new("Invoice already marked as paid in Enspiral.")
  end

  def throw_invalid_xero_status_error(xero_invoice)
    raise XeroErrors::InvalidXeroInvoiceStatusError.new("Invoice #{xero_invoice.invoice_number} has status '#{xero_invoice.status}' on the Xero side, so it won't be imported.")
  end
end