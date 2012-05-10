module InvoicesHelper
  # supporting company, or project, or company/project/invoice

  def pay_and_disburse_options(invoice)
    options = {}
    options[:method] = :post
    options[:confirm] = "Has a payment of #{number_to_currency(invoice.amount_owing)} been made? The allocated funds will be disbursed."
    options[:class] = :btn
    options
  end

  def disburse_options(invoice)
    options = []
    options[:method] = :post
    options[:confirm] = "The funds will be disbursed according to the allocations. Continue?"
    options[:class] = :btn
    options
  end

  def delete_options(invoice)
    {:confirm => "Are you sure?", :method => :delete, class: 'btn'}
  end
end
