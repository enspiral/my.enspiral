class Invoice < ActiveRecord::Base
  belongs_to :customer

  has_many :allocations, :class_name => 'InvoiceAllocation', :dependent => :destroy

  validates_presence_of :customer_id, :amount, :date, :due

  before_destroy :require_unpaid_invoice

  scope :unpaid, lambda { where("paid IS NULL OR paid = false") }
  scope :paid, lambda { where(:paid => true) }

  def mark_as_paid
    allocations.each do |a|
      a.disburse
    end
    update_attribute(:paid, true)
  end

  def allocated
    allocations.sum('amount')
  end

  def allocated?
    unallocated == 0
  end

  def unallocated
    amount - allocated
  end

  def paid?
    paid
  end

  private
  def require_unpaid_invoice
    raise "Can not destroy a paid invoice" if paid
  end

end
