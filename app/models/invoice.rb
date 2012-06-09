class Invoice < ActiveRecord::Base

  default_scope order('created_at DESC')
  scope :unpaid, where(paid: false)
  scope :paid, where(paid: true)
  scope :closed, where(paid: true)
  scope :not_closed, where(paid: false)

  belongs_to :project
  belongs_to :customer
  belongs_to :company
  belongs_to :account

  has_many :people, :through => :allocations, :source => :account

  has_many :allocations,
           :class_name => 'InvoiceAllocation',
           :dependent => :destroy,
           :inverse_of => :invoice

  has_many :payments,
           :after_add => :check_if_fully_paid,
           :inverse_of => :invoice

  accepts_nested_attributes_for :payments, :allocations, :reject_if => :all_blank, :allow_destroy => true

  validates_presence_of :customer, :company, :amount, :date, :due
  validate :not_over_allocated

  before_validation do
    if project and company.nil?
      self.company = project.company
    end
  end

  before_destroy do
    raise "Can not destroy a paid invoice" if payments.size > 0
  end

  define_index do
    has :company_id
    indexes :xero_reference
    indexes customer(:name), as: :customer_name
    indexes people(:name), as: :people_name

    has :id
  end

  def overdue?
    Date.today > due
  end

  def reference
    xero_reference.blank? ? id : xero_reference
  end

  def amount_paid
    payments.sum :amount
  end

  def amount_owing
    amount - amount_paid
  end

  def paid_in_full?
    amount_paid == amount
  end

  def amount_allocated
    allocations.sum :amount
  end

  def allocated_in_full?
    amount_allocated == amount
  end

  def amount_unallocated
    amount - amount_allocated
  end

  def can_be_deleted?
    amount_paid  == 0
  end

  def check_if_fully_paid(payment)
    update_attribute(:paid, true) if amount_paid >= amount
  end

  private
  def not_over_allocated
    # because sum uses database to count.. cannot use ActiveRecord::sum here
    allocated_amount = allocations.map(&:amount).reject{|a| a.blank? }.sum
    if allocated_amount > amount
      errors.add(:amount_allocated, 'Allocations exceed amount of invoice')
    end
  end
end
