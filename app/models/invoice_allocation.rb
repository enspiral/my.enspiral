class InvoiceAllocation < ActiveRecord::Base
  belongs_to :invoice, :inverse_of => :allocations
  belongs_to :account

  validates_presence_of :account, :invoice, :amount, :commission
  validates_numericality_of :commission, greater_than_or_equal_to: 0, less_than_or_equal_to: 1
  validates_numericality_of :amount, greater_than: 0

  validate :account_is_not_closed

  scope :pending, where(disbursed: false)
  scope :disbursed, where(disbursed: true)


  def amount_allocated
    if commission == 0
      amount
    else
      amount * (1 - commission)
    end
  end

  def for_hours
    (hours && hours != 0 ? hours : "NA")
  end

  def at_rate
    if hours && hours != 0
      rate = sprintf("%.2f", amount_allocated/hours)
    else
      "NA"
    end
  end

  def disburse(author)
    return false if disbursed
    raise 'author required' unless author

    pay = FundsTransfer.create!(
            author: author,
            source_account: invoice.company.income_account,
            destination_account: account,
            amount: amount_allocated,
            description: "Payment for invoice ##{invoice.id} (#{invoice.customer.name})",
            source_description: "Payment to #{account.name} for invoice ##{invoice.id} (#{invoice.customer.name})",
            destination_description: "Payment for invoice ##{invoice.id} (#{invoice.customer.name})")

    unless commission == 0
      remainder = FundsTransfer.create!(
              author: author,
              source_account: invoice.company.income_account,
              destination_account: invoice.company.support_account,
              amount: (amount - amount_allocated),
              description: "Contribution of #{commission * 100}% for invoice ##{invoice.id} (#{invoice.customer.name})")
    end

    update_attribute(:disbursed, true)
    invoice.check_if_fully_disbursed
    true
  end

  alias disburse! disburse

  private

  def will_not_overallocate_invoice
    return if amount.nil? #other validations will catch this
    unless amount + invoice.amount_allocated <= invoice.amount
      errors.add(:amount, "would over allocate the invoice amount of #{invoice.amount}")
    end
  end

  def account_is_not_closed
    errors.add(:account, 'Cannot allocate to a closed account') if account.closed?
  end
end
