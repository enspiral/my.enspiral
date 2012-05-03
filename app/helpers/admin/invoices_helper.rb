module Admin::InvoicesHelper

  def link_to_pay_and_disburse_company_invoice(*args, &block)
    if block_given?
      url = args[0]
      html_options = args[1] || {}
      link_to_pay_and_disburse_company_invoice(capture(&block), url, html_options)
    else
      name = args[0]
      url = args[1]
      html_options = args[2] || {}
      company = url[0]
      invoice = url[1]
      html_options[:method] = :post
      html_options[:confirm] = "Has a payment of #{number_to_currency(invoice.amount_owing)} been made? The allocated funds will be disbursed."
      link_to name, pay_and_disburse_company_invoice_path(*url), html_options
    end
  end

  def link_to_disburse_company_invoice(*args, &block)
    if block_given?
      url = args[0]
      html_options = args[1] || {}
      link_to_disburse_company_invoice(capture(&block), url, html_options)
    else
      name = args[0]
      url = args[1]
      html_options = args[2] || {}
      company = url[0]
      invoice = url[1]
      html_options[:method] = :post
      html_options[:confirm] = "The funds will be disbursed according to the allocations. Continue?"
      link_to 'Disburse all', disburse_company_invoice_path(*url), html_options
    end
  end
end
