class Invoice < ActiveRecord::Base

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

  def overdue?
    Date.today > due
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
    update_attribute(:paid, true) if amount_paid >= amount
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

  def self.insert_single_invoice inv
    company_id = Company.find_by_name("Enspiral Services").id
    if inv.invoice_number
      if inv.invoice_number.include?("INV-")
        xero_ref = inv.invoice_number.delete("INV-")
        if Customer.find_by_name(inv.contact.name)
          customer = Customer.find_by_name(inv.contact.name)
        else
          customer = Customer.create!(:name => inv.contact.name, :company_id => company_id, :approved => false)
        end
      end
    else
      xero_ref = nil
    end
    amount = inv.sub_total
    date = inv.date
    currency = inv.currency_code
    due_date = inv.due_date
    # if inv.status == "AUTHORISED" || inv.status == "PAID" || inv.status == "SUBMITTED"
    #   valid_status = true
    # else
    #   valid_status = false
    # end
    valid_status = true
    xero_link = "https://go.xero.com/AccountsReceivable/View.aspx?InvoiceID=#{inv.invoice_id}"
    if xero_ref && customer && amount && date && due_date && currency == "NZD" && valid_status
      if !Invoice.find_by_xero_reference_and_customer_id(xero_ref, customer.id)
        saved_invoice = Invoice.create!(:customer_id => customer.id, :amount => amount, :date => date, :due => due_date, :xero_reference => xero_ref, :company_id => company_id, :approved => false, :currency => currency, :imported => false, :xero_link => xero_link)
        if inv.line_items.count > 0
          Invoice.import_line_items inv, saved_invoice if saved_invoice
        end
      end
    end
  end

  def self.import_line_items inv, saved_invoice
    inv.line_items.each do |el|
      allocation = el.tracking.split("-")
      allocation_currency = inv.currency_code
      allocation_amount = el.line_amount
      allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral Account")
      allocation_contribution = allocation[1]
      if allocation_amount && allocation_account && allocation_contribution
        InvoiceAllocation.create!(:invoice_id => saved_invoice.id, :amount => allocation_amount, :currency => allocation_currency, :contribution => allocation_contribution, :account_id => allocation_account.id)
      end
    end
  end

  def self.insert_new_invoice invoices
    imported_count = 0
    invoices.each do |inv|
      company_id = Company.find_by_name("Enspiral Services").id
      xero_ref = nil
      if inv.invoice_number
        if inv.invoice_number.include?("INV-")
          xero_ref = inv.invoice_number.delete("INV-")
          if Customer.find_by_name(inv.contact.name)
            customer = Customer.find_by_name(inv.contact.name)
          else
            customer = Customer.create!(:name => inv.contact.name, :company_id => company_id, :approved => false)
          end
        end
      end
      amount = inv.sub_total
      date = inv.date
      currency = inv.currency_code
      due_date = inv.due_date
      if inv.status == "AUTHORISED" || inv.status == "PAID"
        valid_status = true
      else
        valid_status = false
      end
      xero_link = "https://go.xero.com/AccountsReceivable/View.aspx?InvoiceID=#{inv.invoice_id}"
      if xero_ref && customer && amount && date && due_date && currency == "NZD" && valid_status
        if !Invoice.find_by_xero_reference_and_customer_id(xero_ref, customer.id)
          imported_count = imported_count + 1
          Invoice.create!(:customer_id => customer.id, :amount => amount, :date => date, :due => due_date, :xero_reference => xero_ref, :company_id => company_id, :approved => false, :currency => currency, :imported => true, :xero_link => xero_link)
        end
      end
    end

    if imported_count > 0
      invoices = Invoice.where(:imported => true)
      invoices.each_with_index do |inv, i|
        if i > 1
          inv.imported = false
          inv.save!
        end
      end
    end
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

  def unallocated?
    InvoiceAllocation.find_by_invoice_id(self.id) == nil
  end

  def approve!
    update_attribute(:approved, true)
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
