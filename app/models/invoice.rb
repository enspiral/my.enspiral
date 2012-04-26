class Invoice < ActiveRecord::Base
  belongs_to :customer
  belongs_to :company
  belongs_to :account

  has_many :allocations,
           :class_name => 'InvoiceAllocation',
           :dependent => :destroy

  has_many :pending_allocations,
           :class_name => 'InvoiceAllocation',
           :conditions => {:disbursed => false},
           :dependent => :destroy

  has_many :payments,
           :after_add => :check_if_fully_paid
  accepts_nested_attributes_for :payments, :pending_allocations, :reject_if => :all_blank, :allow_destroy => true

  validates_presence_of :customer, :company, :amount, :date, :due


  before_destroy do
    raise "Can not destroy a paid invoice" if payments.size > 0
  end

  scope :unpaid, where(paid: false)
  scope :paid, where(paid: true)

  def amount_paid
    payments.sum :amount
  end

  def amount_disbursed
    allocations.disbursed.sum :amount
  end

  def disburse!(author)
    allocations.each do |a|
      a.disburse(author)
    end
  end

  def amount_allocated
    allocations.pluck(:amount).sum
  end

  def allocated?
    unallocated == 0
  end

  def unallocated
    amount - amount_allocated
  end

  def check_if_fully_disbursed
    if amount_disbursed == amount
      update_attribute(:disbursed, true)
    elsif amount_disbursed > amount
      raise 'Amount disbursed greater than amount!'
    end
  end

  private
  def check_if_fully_paid(payment)
    update_attribute(:paid, true) if amount_paid >= amount
  end
end
