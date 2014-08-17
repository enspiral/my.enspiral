class InvoiceAllocation < ActiveRecord::Base
  belongs_to :invoice, :inverse_of => :allocations
  belongs_to :account

  validates_presence_of :account, :invoice, :amount, :contribution
  validates_numericality_of :contribution, greater_than_or_equal_to: 0, less_than_or_equal_to: 1
  validates_numericality_of :amount, greater_than: 0

  validate :account_is_not_closed
  has_many :payments

  scope :pending, where(disbursed: false)
  scope :invoice_paid_on,
    joins(:invoice).select("*, invoices.updated_at as updated, invoice_allocations.amount as allocated_amount").order("updated DESC")

  def name
    "#{account.name} $#{amount}"
  end

  def renumeration_amount
    amount * (1 - contribution)
  end

  def validate_reverse_payment
    transaction = self.account.transactions.new(amount: -amount, description: "reverse payment from account #{self.name}", date: Date.today)
    transaction.valid?
  end

  def reverse_payment
    contribution_amount = self.amount * self.contribution
    renumeration_amount = self.amount - contribution_amount
    if self.team_account_id
      contribution_team_amount = contribution_amount / 8.0
      contribution_support_amount = contribution_amount - contribution_team_amount
      team_account = Account.find(self.team_account_id)

      team_account.reverse_payment contribution_team_amount
      self.account.company.support_account.reverse_payment contribution_support_amount
      self.account.reverse_payment renumeration_amount
    else
      self.account.reverse_payment renumeration_amount
      self.account.company.support_account.reverse_payment contribution_amount
    end
  end

  def contribution_amount
    amount * contribution
  end

  def amount_paid
    #disbursed is for invoices that were paid before the upgrades in June 2012
    disbursed ? amount : payments.sum(:amount)
  end

  def amount_owing
    #disbursed is for invoices that were paid before the upgrades in June 2012
    disbursed ? 0 : amount - amount_paid
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
