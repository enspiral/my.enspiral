class Invoice < ActiveRecord::Base
  belongs_to :customer

  has_many :allocations, :class_name => 'InvoiceAllocation', :dependent => :destroy

  before_destroy :require_unpaid_invoice

  named_scope :unpaid, :conditions => "paid IS NULL OR paid = false"
  named_scope :paid, :conditions => {:paid => true}

  def mark_as_paid
    allocations.each do |a|
      a.disburse
    end
    update_attribute(:paid, true)
  end

  def allocated
    allocations.sum('amount')
  end

  def unallocated
    amount - allocated
  end

  private
  def require_unpaid_invoice
    raise "Can not destroy a paid invoice" if paid
  end

end
