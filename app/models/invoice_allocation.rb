class InvoiceAllocation < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :account

  before_create :copy_commission

  validates_presence_of :account_id, :invoice_id, :amount
  validates_numericality_of :commission, :greater_than => 0
  validates_numericality_of :amount, :greater_than => 0

  validate :will_not_overallocate_invoice

  scope :pending, lambda { where("disbursed IS NULL OR disbursed = false") }
  scope :disbursed, lambda { where(:disbursed => true) }

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
    self.commission = account.person.base_commission if account && account.person.present?
  end

  def will_not_overallocate_invoice
    return if amount.nil? #other validations will catch this
    unless amount + invoice.allocated <= invoice.amount
      errors.add(:amount, "would over allocate the invoice amount of #{invoice.amount}")
    end
  end
end
