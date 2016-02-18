require 'xero_import'

class Invoice < ActiveRecord::Base
  include ApplicationHelper
  extend XeroImport

  default_scope order('date DESC, xero_reference DESC')
  scope :unpaid, where(paid: false)
  scope :paid, where(paid: true)
  scope :unapproved, where(approved: false)
  scope :approved, where(approved: true)
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
  validates_uniqueness_of :xero_reference, allow_blank: true, scope: :company_id

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

  def xero_link
    return "#" unless xero_id
    "https://go.xero.com/AccountsReceivable/View.aspx?InvoiceID=#{xero_id}"
  end

  def overdue?
    begin
      today_in_zone(company) > due
    rescue => e
      Date.today > due
    end
  end

  def reference
    xero_reference.blank? ? "Enspiral: #{id}" : "Xero: #{xero_reference}"
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
    if amount_paid >= amount
      pay!
    end
  end

  def paid_on
    paid ? self[:paid_on] : nil
  end

  def pay!
    self.paid = true
    self.paid_on = Time.zone.now
    self.approved = true
    self.save
  end

  def can_close?
    not paid_in_full? and amount_unallocated == 0
  end

  def self.get_unallocated_invoice invoices
    arr_id = []
    invoice_allocations = InvoiceAllocation.select(:invoice_id)
    invoice_allocations.each do |el|
      arr_id.push(el.invoice_id)
    end
    return invoices.where(["id not in (?)", arr_id])
  end

  def reconcile!
    update_attribute(:paid, true)
  end

  def close!(author)
    if can_close?
      allocations.each do |a|
        if a.amount_owing > 0
          payments.create!(invoice_allocation: a, amount: a.amount_owing, author: author)
        end
      end
    end
  end

  def approve!
    update_attribute(:approved, true)
  end

  def unallocated?
    InvoiceAllocation.find_by_invoice_id(self.id) == nil
  end

  def self.is_numeric value
    Integer(value) rescue false
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
