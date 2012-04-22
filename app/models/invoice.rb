class Invoice < ActiveRecord::Base
  belongs_to :customer
  belongs_to :company

  has_many :allocations,
           :class_name => 'InvoiceAllocation',
           :dependent => :destroy
  has_many :payments

  validates_presence_of :customer, :company, :amount, :date, :due


  before_destroy do
    raise "Can not destroy a paid invoice" if paid
  end

  scope :unpaid, where(paid: false)
  scope :paid, where(paid: true)

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
end
