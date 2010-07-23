class InvoiceAllocation < ActiveRecord::Base
  belongs_to :person
  belongs_to :invoice

  before_create :copy_commission_from_person

  validates_presence_of :person_id, :invoice_id, :amount
  validates_numericality_of :commission, :greater_than => 0
  validates_numericality_of :amount, :greater_than => 0

  validate :will_not_overallocate_invoice

  named_scope :pending, :conditions => "disbursed IS NULL OR disbursed = false"
  named_scope :disbursed, :conditions => "disbursed = true"

  def amount_allocated
    amount * (1 - commission)
  end

  def for_hours
    (0 == 0 ? "NA" : 1)
  end

  def at_rate
    (0 == 0 ? "NA" : 1)
  end

  def disburse
    return false if disbursed

    Transaction.create(
      :amount => amount_allocated,
      :account => person.account,
      :date => Time.now,
      :description => "Payment received from #{invoice.customer.name}"
    )
    update_attribute(:disbursed, true)
  end

  private
  def copy_commission_from_person
    self.commission = person.base_commission
  end

  def will_not_overallocate_invoice
    return if amount.nil? #other validations will catch this
    unless amount + invoice.allocated <= invoice.amount
      errors.add(:amount, "would over allocate the invoice amount of #{invoice.amount}")
    end
  end
end
