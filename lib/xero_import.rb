require 'xero_errors'
require 'loggers/import_logger'

module XeroImport
  include XeroErrors
  include Loggers

  # this code is being refactored from existing code which is in dire need of cleanup
  # it's not mine! git blame lies! #buckpass
  # -c

  def insert_single_invoice inv
    company_id = Company.find_by_name("#{APP_CONFIG[:organization_full]}").id
    if inv.invoice_number
      if inv.invoice_number.include?("INV-")
        xero_ref = inv.invoice_number.delete("INV-")
        if Customer.find_by_name(inv.contact.name)
          customer = Customer.find_by_name(inv.contact.name)
        else
          customer = Customer.create!(:name => inv.contact.name, :company_id => company_id, :approved => false)
        end
      else
        throw_invoice_format_error
      end
    else
      xero_ref = nil
    end
    amount = inv.sub_total
    date = inv.date
    currency = inv.currency_code
    due_date = inv.due_date
    # if inv.status == "AUTHORISED" || inv.status == "PAID" || inv.status == "SUBMITTED"
    #   valid_status = true
    # else
    #   valid_status = false
    # end
    valid_status = true
    xero_link = "https://go.xero.com/AccountsReceivable/View.aspx?InvoiceID=#{inv.invoice_id}"
    if xero_ref && customer && amount && date && due_date && currency == "NZD" && valid_status
      if !Invoice.find_by_xero_reference_and_customer_id(xero_ref, customer.id)
        saved_invoice = Invoice.create!(customer_id: customer.id, amount: amount, date: date, due: due_date, xero_reference: xero_ref, xero_id: inv.invoice_id,
                                        company_id: company_id, approved: false, currency: currency, imported: false, xero_link: xero_link)
        if inv.line_items.count > 0
          Invoice.import_line_items inv, saved_invoice if saved_invoice
        end
        saved_invoice
      end
    end
  end

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
    invoices.each do |inv|
      if inv.invoice_number.include?("INV-")
        xero_ref = inv.invoice_number.delete("INV-")
        enspiral_invoice = Invoice.find_by_xero_reference(xero_ref)
        if enspiral_invoice && enspiral_invoice.amount != inv.attributes[:sub_total]
          fault_invoices << xero_ref
          # enspiral_invoice.amount = inv.attributes[:sub_total]
          # enspiral_invoice.save!
        end
      end
    end
    fault_invoices
  end

  def update_all_existing_invoice xero_invoices
    invoices_count = 0
    import_result = {}
    import_result[:errors] = {}
    xero_invoices.each do |xero_invoice|
      invoices_count += 1
      if invoices_count > 50
        puts "sleeping ....."
        sleep(60)
        puts "wake up !"
        invoices_count = 0
      end

      begin
        update_existing_invoice xero_invoice
      rescue => e
        import_result[:errors][xero_invoice.invoice_id] = e
      end
    end
    import_result[:count] = invoices_count
    import_result
  end

  def update_existing_invoice xero_invoice
    throw_invoice_format_error unless xero_invoice.invoice_number.include?("INV-")
    xero_ref = xero_invoice.invoice_number.delete("INV-")
    enspiral_invoice = Invoice.find_by_xero_reference(xero_ref)
    return unless enspiral_invoice
    throw_already_paid_error if enspiral_invoice.paid

    if xero_invoice.contact.name != enspiral_invoice.customer.name
      if Customer.find_by_name(xero_invoice.contact.name)
        customer = Customer.find_by_name(xero_invoice.contact.name)
      else
        customer = Customer.create!(:name => xero_invoice.contact.name, :company_id => company_id, :approved => false)
      end
      enspiral_invoice.customer = customer if customer
    end

    if xero_invoice.attributes[:sub_total] != enspiral_invoice.amount
      enspiral_invoice.amount = xero_invoice.attributes[:sub_total]
    end

    enspiral_invoice.xero_id = xero_invoice.invoice_id

    if xero_invoice.date != enspiral_invoice.date
      enspiral_invoice.date = xero_invoice.date
    end

    if xero_invoice.due_date != enspiral_invoice.due
      enspiral_invoice.due = xero_invoice.due_date
    end

    if enspiral_invoice.allocations.count > 0
      enspiral_invoice.allocations.destroy_all
    end

    if xero_invoice.line_items.count > 0
      # Invoice.check_discount_value_in_line_item inv, enspiral_invoice
      Invoice.import_line_items xero_invoice, enspiral_invoice
    end

    enspiral_invoice.save!

    if xero_invoice.status == "VOIDED"
      # enspiral_invoice.destroy
    end
    enspiral_invoice
  end

  def insert_new_invoice invoices
    import_result = {}
    import_result[:errors] = {}
    invoices_count = 0
    company_id = Company.find_by_name("#{APP_CONFIG[:organization_full]}").id
    invoices.each do |inv|
      invoices_count += 1
      if invoices_count > 30
        puts "sleeping ....."
        sleep(60)
        puts "wake up !"
        invoices_count = 0
      end

      begin
        new_invoice_from_xero_invoice(inv, company_id)
      rescue => e
        import_result[:errors][inv.invoice_id] = e
      end
    end

    if Invoice.where(:imported => true).count > 1
      invoices = Invoice.where(:imported => true)
      invoices.each_with_index do |inv, i|
        if i > 1
          inv.imported = false
          inv.save
        end
      end
    end

    import_result[:count] = invoices_count
    import_result
  end

  def new_invoice_from_xero_invoice(inv, company_id)
    xero_ref = nil
    if inv.invoice_number
      if inv.invoice_number.include?("INV-")
        xero_ref = inv.invoice_number.delete("INV-")
        if Customer.find_by_name(inv.contact.name)
          customer = Customer.find_by_name(inv.contact.name)
        else
          customer = Customer.create!(:name => inv.contact.name, :company_id => company_id, :approved => false)
        end
      else
        throw_invoice_format_error
      end
    end
    amount = inv.attributes[:sub_total]
    date = inv.date
    currency = inv.currency_code
    due_date = inv.due_date
    if inv.status == "AUTHORISED" || inv.status == "PAID"
      valid_status = true
    else
      valid_status = false
    end
    xero_link = "https://go.xero.com/AccountsReceivable/View.aspx?InvoiceID=#{inv.invoice_id}"
    if xero_ref && customer && amount && date && due_date && valid_status
      if !Invoice.find_by_xero_reference_and_customer_id(xero_ref, customer.id)
        if !Invoice.find_by_xero_reference(xero_ref)
          saved_invoice = Invoice.create(:customer_id => customer.id,
                                         :amount => amount, :date => date,
                                         :due => due_date, :xero_reference => xero_ref,
                                         :company_id => company_id, :approved => false,
                                         :currency => currency, :imported => true,
                                         xero_id: inv.invoice_id,
                                         :xero_link => xero_link)

          if inv.line_items.count > 0
            discount_existed = Invoice.check_discount_value_in_line_item inv
            if discount_existed
              Invoice.import_discount_line_items inv, saved_invoice if saved_invoice
            else
              Invoice.import_line_items inv, saved_invoice if saved_invoice
            end
          end
        end
      end
    end
  end

  def throw_invoice_format_error
    raise XeroErrors::UnrecognisedInvoiceReferenceFormat.new("Cannot recognise #{inv.invoice_number} as a valid invoice format (expecting it to be in format INV-xxxx)")
  end

  def throw_already_paid_error
    raise XeroErrors::EnspiralInvoiceAlreadyPaidError.new("Invoice already marked as paid in Enspiral.")
  end
end