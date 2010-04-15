class InvoiceAllocation < ActiveRecord::Base
  belongs_to :person
  belongs_to :invoice

  before_create :copy_commission_from_person

  validates_numericality_of :commission, :greater_than => 0

  named_scope :pending, :conditions => {:disbursed => false}

  def amount_allocated
    amount * (1 - commission)
  end

  def disburse
    return false if disbursed

    Transaction.create(
      :amount => amount_allocated,
      :account => person.account,
      :date => Time.now,
      :description => "Payment received from #{invoice.customer.name} invoice ##{invoice.number}"
    )
    update_attribute(:disbursed, true)
  end

  private
  def copy_commission_from_person
    self.commission = person.base_commission
  end
end
