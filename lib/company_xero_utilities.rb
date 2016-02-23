require 'loggers/import_logger'
require 'xero_errors'
require 'xero_import'

module CompanyXeroUtilities
  include Loggers
  include XeroErrors
  include XeroImport

  def xero?
    xero_consumer_key.present? && xero_consumer_secret.present?
  end

  def xero
    @xero ||= Xeroizer::PrivateApplication.new(xero_consumer_key, xero_consumer_secret, "#{Rails.root}/config/xero/privatekey.pem", :rate_limit_sleep => 3)
  end

  def find_xero_invoice(xero_invoice_id)
    self.xero.Invoice.find(xero_invoice_id)
  end

  def find_all_xero_invoices(hash)
    self.xero.Invoice.all(hash)
  end

  def import_xero_invoice_by_reference xero_ref, overwrite = false
    import_xero_invoice(xero_ref, overwrite)
  end

  def import_xero_invoice ref, overwrite = false
    existing_invoice = find_enspiral_invoice(ref)
    xero_invoice = find_xero_invoice_by_id_or_reference(ref)

    if existing_invoice
      return update_existing_invoice(xero_invoice, existing_invoice) if overwrite.present?
      raise EnspiralInvoiceAlreadyPaidError.new("That invoice has been marked as paid and cannot be modified") if existing_invoice.paid?
      raise InvoiceAlreadyExistsError.new("Invoice #{existing_invoice.xero_reference} already exists - please check manually", existing_invoice, xero_invoice)
    else
      new_invoice = Invoice.insert_single_invoice xero_invoice
      raise NoInvoiceCreatedError.new("No invoice created", existing_invoice, xero_invoice, overwrite) unless new_invoice
    end

  end

  def find_enspiral_invoice(ref)
    existing_invoices = Invoice.where(xero_id: ref)
    existing_invoices = Invoice.where(xero_reference: ref) if existing_invoices.empty?
    if existing_invoices.count == 1
      return existing_invoices.first
    elsif existing_invoices.count > 1
      raise AmbiguousInvoiceError.new("There are #{existing_invoices.count} with reference #{ref}: #{existing_invoices.map(&:xero_reference).join(", ")}")
    end
    nil
  end

  def find_xero_invoice_by_id_or_reference(ref)
    begin
      find_xero_invoice(ref)
    rescue
      begin
        find_xero_invoice(ref)
      rescue => e
        raise Xeroizer::InvoiceNotFoundError.new("Invoice #{ref} doesn't seem to exist in Xero") if e.is_a? Xeroizer::InvoiceNotFoundError
        raise e
      end
    end
  end


  ################## original, un-refactored code #####################

  def import_xero_invoices
    # find latest invoice with the "imported" flag. I did not write this!
    invoices = Invoice.where(imported: true, company_id: self.id).order(:date)
    if invoices.any?
      invoice = invoices.first
    else
      invoices = Invoice.where(company_id: self.id).order(:date)
      if invoices.any?
        invoice = invoices.first
      end
    end

    if invoice
      xero_date = (invoice.date - 1.month).beginning_of_month
      puts "Finding all invoices after #{xero_date}"
      xero_invoices = find_all_xero_invoices(:where => "Date>=DateTime.Parse(\"#{xero_date.to_time.utc.iso8601}\")&&Type=\"ACCREC\"&&Status<>\"DRAFT\"&&Status<>\"DELETED\"&&Status<>\"SUBMITTED\"&&Status<>\"VOIDED\"")
    else
      xero_invoices = find_all_xero_invoices(:where => 'Type="ACCREC"&&Status<>"DRAFT"&&Status<>"DELETED"&&Status<>"SUBMITTED"&&Status<>"VOIDED"')
    end

    result = Invoice.import_invoices_from_xero xero_invoices, self
    result[:count] = xero_invoices.count
    log_results(result)
    save_to_db(result, self)
    alert_admins(result) if result[:errors].any?
    result
  end

  def check_invoice_and_update
    xero_ref = Invoice.where(:imported => true).first.xero_reference
    xero_invoice = find_xero_invoice(xero_ref)
    if xero_invoice
      xero_date = (xero_invoice.date - 2.month).beginning_of_month
    end
    invoices = find_all_xero_invoices(:where => {:date_is_greater_than_or_equal_to => xero_date, :type => "ACCREC", :status => "AUTHORISED"})
    Invoice.update_all_existing_invoice invoices
  end

  def alert_admins(result)
    puts "Alerting admins: #{result[:errors].count} out of #{result[:count]} failed to import"
    mail = Notifier.alert_company_admins_of_failing_invoice_import(self, result[:count], result[:errors])
    mail.deliver
  end

  ############################## reporting ######################################

  def generate_manual_cash_position date_from, date_to
    result = []
    from = date_from.to_date
    to = date_to.to_date

    bank_balance = self.xero.BankSummary.get(:fromDate => from, :toDate => to).rows.last.rows.last.cells.last.value
    result << {"Bank Balance" => [bank_balance]}

    staff_accounts = self.accounts.not_closed.not_expense
    staff_accounts_balance = balance_for_accounts(staff_accounts, to)

    positive_accounts = staff_accounts.select {|ac| ac.balance > 0}
    positive_accounts_balance = balance_for_accounts(positive_accounts, to)
    result << {"Positive Accounts" => [positive_accounts_balance]}

    negative_accounts = staff_accounts.select {|ac| ac.balance < 0}
    negative_accounts_balance = balance_for_accounts(negative_accounts, to)
    result << {"- Negative Accounts" => [negative_accounts_balance * -1]}

    net_staff_accounts_balance = staff_accounts_balance
    ["Tax Paid", "Collective Funds", "Bucket", "Team"].each do |type_name|
      balance = balance_for_account_type(staff_accounts, type_name, to)
      net_staff_accounts_balance -= balance
      result << {" - '#{type_name}' Accounts" => [balance]}
    end

    result << {"Net Staff Accounts" => [net_staff_accounts_balance]}

    fund_after_paid_out = bank_balance - net_staff_accounts_balance
    result << {"Funds after staff paid out" => [fund_after_paid_out]}

    ytd_net_profit = self.xero.ProfitAndLoss.get(:fromDate => beginning_of_financial_year(date_from), :toDate => to).rows.last.rows.last.cells.last.value
    result << {"YTD Net Profit" => [ytd_net_profit]}

    result << {"- Net Staff Accounts" => [net_staff_accounts_balance]}

    net_profit = ytd_net_profit - net_staff_accounts_balance
    result << {"Net Profit/(Loss)" => [net_profit]}

    tax_to_date = net_profit - 72850.51 < 0 ? 0 : (net_profit - 72850.51) * 0.28
    result << {"Tax to date" => [tax_to_date]}

    # result
    result = result.inject{|memo, el| memo.merge( el ){|k, old_v, new_v| old_v + new_v}}
  end

end
