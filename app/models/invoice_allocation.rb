class InvoiceAllocation < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :account
  belongs_to :person

  before_create :copy_commission

  validates_presence_of :account, :invoice, :amount
  validates_numericality_of :commission, :greater_than => 0
  validates_numericality_of :amount, :greater_than => 0

  validate :will_not_overallocate_invoice

  scope :pending, where(disbursed: false)
  scope :disbursed, where(disbursed: true)

  def amount_allocated
    amount * (1 - commission)
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
    
    pay = FundsTransfer.create!(
            author: author,
            source_account: invoice.company.income_account,
            destination_account: account,
            amount: amount_allocated,
            source_description: "Payment to #{account.name} for services to #{invoice.customer.name} for invoice ##{invoice.id}",
            destination_description: "Payment for services to #{invoice.customer.name} invoice ##{invoice.id}")

    remainder = FundsTransfer.create!(
                  author: author,
                  source_account: invoice.company.income_account,
                  destination_account: invoice.company.support_account,
                  amount: (amount - amount_allocated),
                  description: "Company commission of #{commission} for services to #{invoice.customer.name} for invoice ##{invoice.id}")

    update_attribute(:disbursed, true) if pay and remainder
  end

  private

  #copies commission from person
  def copy_commission
    self.commission = person.base_commission if person.present?
  end

  def will_not_overallocate_invoice
    return if amount.nil? #other validations will catch this
    unless amount + invoice.allocated <= invoice.amount
      errors.add(:amount, "would over allocate the invoice amount of #{invoice.amount}")
    end
  end
end
