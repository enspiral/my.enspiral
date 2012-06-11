class InvoiceAllocation < ActiveRecord::Base
  belongs_to :invoice, :inverse_of => :allocations
  belongs_to :account

  validates_presence_of :account, :invoice, :amount, :contribution
  validates_numericality_of :contribution, greater_than_or_equal_to: 0, less_than_or_equal_to: 1
  validates_numericality_of :amount, greater_than: 0

  validate :account_is_not_closed
  has_many :payments

  scope :pending, where(disbursed: false)

  def name
    "#{account.name} $#{amount}"
  end

  def renumeration_amount
    amount * (1 - contribution)
  end

  def contribution_amount
    amount * contribution
  end

  def amount_paid
    payments.sum(:amount)
  end

  def amount_owing
    amount - amount_paid
  end

  def paid?
    amount_owing == 0
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

  private

  def will_not_overallocate_invoice
    return if amount.nil? #other validations will catch this
    unless amount + invoice.amount_allocated <= invoice.amount
      errors.add(:amount, "would over allocate the invoice amount of #{invoice.amount}")
    end
  end

  def account_is_not_closed
    errors.add(:account, 'Cannot allocate to a closed account') if account and account.closed?
  end
end
