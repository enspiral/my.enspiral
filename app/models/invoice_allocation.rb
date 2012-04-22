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

  def disburse
    return false if disbursed

    t = Transaction.create(
      :amount => amount_allocated,
      :account_id => self.account.id,
      :date => Time.now,
      :description => "Payment received from #{invoice.customer.name}"
    )
    update_attribute(:disbursed, true) if t
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
