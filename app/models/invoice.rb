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
    Time.now.in_time_zone(company.time_zone).to_date > due
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
      update_attribute(:paid, true)
      update_attribute(:approved, true)
    end
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
    company_id = Company.find_by_name("#{APP_CONFIG[:organization_full]}").id
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

  def self.check_discount_value_in_line_item inv
    inv.line_items.each do |el|
      return true if el.attributes[:line_amount] < 0
    end
    return false
  end

  def self.import_discount_line_items inv, saved_invoice
    allocation_personal_with_discount = ""
    allocation_amount_with_discount = 0
    total_positive_line_item = 0
    allocation_amount = 0
    allocation_account = ""
    allocation_contribution = 0
    allocation_team_account = ""
    total_line_item_with_discount = 0
    allocation_currency = ""
    inv.line_items.each do |el|
      if el.attributes[:line_amount] < 0
        allocation_personal_with_discount = el.tracking[1].option
        allocation_amount_with_discount = el.attributes[:line_amount]
      end
    end

    inv.line_items.each do |el|
      if el.tracking[1].option == allocation_personal_with_discount && el.attributes[:line_amount] > 0
        total_positive_line_item = total_positive_line_item + el.attributes[:line_amount]
      end
    end
    total_line_item_with_discount = total_positive_line_item + allocation_amount_with_discount

    inv.line_items.each do |el|
      allocation_team = el.tracking[0].option
      allocation_personal = el.tracking[1].option
      allocation = allocation_personal.split("-")
      allocation_currency = inv.currency_code
      if el.tracking[1].option == allocation_personal_with_discount && el.attributes[:line_amount] > 0
         line_percentage = el.attributes[:line_amount] / total_positive_line_item
         line_discount_value = line_percentage * allocation_amount_with_discount
         allocation_amount = el.attributes[:line_amount] + line_discount_value
      end
      if Account.find_by_name("#{allocation[0]}'s Enspiral Account")
        allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral Account")
      elsif Account.find_by_name("#{allocation[0]}'s Enspiral account")
        allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral account")
      elsif Account.find_by_name("#{allocation[0]}'s Enspiral Services account")
        allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral Services account")
      elsif Account.find_by_name("#{allocation[0]}")
        allocation_account = Account.find_by_name("#{allocation[0]}")
      end
      allocation_team_account = Account.find_by_name("TEAM: #{allocation_team}")
      allocation_contribution = allocation[1].to_i / 100.0
      if el.attributes[:line_amount] > 0 && allocation_amount && allocation_account && allocation_account.closed == false && allocation_contribution && allocation_team_account
        if allocation_amount > 0
          InvoiceAllocation.create!(:invoice_id => saved_invoice.id, 
                                    :amount => allocation_amount, 
                                    :currency => allocation_currency, 
                                    :contribution => allocation_contribution, 
                                    :account_id => allocation_account.id,
                                    :team_account_id => allocation_team_account.id)
        else
          inv_allocation = InvoiceAllocation.where(:invoice_id => saved_invoice.id,
                                  :account_id => allocation_account.id,
                                  :team_account_id => allocation_team_account.id)
          
          if inv_allocation.count > 0
            inv_allocation[0].amount = inv_allocation[0].amount + allocation_amount
            inv_allocation[0].save!
          end
        end
      end
    end
  end

  def self.import_line_items inv, saved_invoice
    inv.line_items.each do |el|
      if el.tracking.count == 1 && el.tracking[0].name == "Team"
        allocation_team = el.tracking[0].option
        allocation_personal = el.tracking[0].option
        allocation_currency = inv.currency_code
        # if el.attributes[:tax_amount]
        #   allocation_amount = el.attributes[:line_amount] - el.attributes[:tax_amount]
        # else
          allocation_amount = el.attributes[:line_amount]
        # end
        allocation_account = Account.find_by_name("TEAM: #{allocation_team}")
        allocation_team_account = Account.find_by_name("TEAM: #{allocation_team}")
        allocation_contribution = 0.20
      elsif el.tracking.count == 2
        allocation_team = el.tracking[0].option
        allocation_personal = el.tracking[1].option
        allocation = allocation_personal.split("-")
        allocation_currency = inv.currency_code
        # if el.attributes[:tax_amount]
        #   allocation_amount = el.attributes[:line_amount] - el.attributes[:tax_amount]
        # else
          allocation_amount = el.attributes[:line_amount]
        # end
        if Account.find_by_name("#{allocation[0]}'s Enspiral Account")
          allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral Account")
        elsif Account.find_by_name("#{allocation[0]}'s Enspiral account")
          allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral account")
        elsif Account.find_by_name("#{allocation[0]}'s Enspiral Services account")
          allocation_account = Account.find_by_name("#{allocation[0]}'s Enspiral Services account")
        elsif Account.find_by_name("#{allocation[0]}")
          allocation_account = Account.find_by_name("#{allocation[0]}")
        end
        allocation_team_account = Account.find_by_name("TEAM: #{allocation_team}")
        allocation_contribution = allocation[1].to_i / 100.0
      end
      if allocation_amount && allocation_account && allocation_account.closed == false && allocation_contribution && allocation_team_account
        if allocation_amount > 0
          InvoiceAllocation.create!(:invoice_id => saved_invoice.id, 
                                    :amount => allocation_amount, 
                                    :currency => allocation_currency, 
                                    :contribution => allocation_contribution, 
                                    :account_id => allocation_account.id,
                                    :team_account_id => allocation_team_account.id)
        else
          inv_allocation = InvoiceAllocation.where(:invoice_id => saved_invoice.id,
                                  :account_id => allocation_account.id,
                                  :team_account_id => allocation_team_account.id)
          
          if inv_allocation.count > 0
            inv_allocation[0].amount = inv_allocation[0].amount + allocation_amount
            inv_allocation[0].save!
          end
        end
      end
    end
  end

  def self.find_fault_subtotal invoices
    fault_invoices = []
    invoices.each do |inv|
      if inv.invoice_number.include?("INV-")
        xero_ref = inv.invoice_number.delete("INV-")
        enspiral_invoice = Invoice.find_by_xero_reference(xero_ref)
        if enspiral_invoice && enspiral_invoice.amount != inv.attributes[:sub_total]
          fault_invoices << xero_ref
          # enspiral_invoice.amount = inv.attributes[:sub_total]
          # enspiral_invoice.save!
        end
      end
    end
    fault_invoices
  end

  def self.update_existed_invoice invoices
    invoices_count = 0
    invoices.each do |inv|
      invoices_count = invoices_count + 1
      if invoices_count > 50
        puts "sleeping ....."
        sleep(60)
        puts "wake up !"
        invoices_count = 0
      end
      if inv.invoice_number.include?("INV-")
        xero_ref = inv.invoice_number.delete("INV-")
        enspiral_invoice = Invoice.find_by_xero_reference(xero_ref)
        if enspiral_invoice && enspiral_invoice.paid == false

          if inv.contact.name != enspiral_invoice.customer.name
            if Customer.find_by_name(inv.contact.name)
              customer = Customer.find_by_name(inv.contact.name)
            else
              customer = Customer.create!(:name => inv.contact.name, :company_id => company_id, :approved => false)
            end
            enspiral_invoice.customer = customer if customer
          end

          if inv.attributes[:sub_total] != enspiral_invoice.amount
            enspiral_invoice.amount = inv.attributes[:sub_total]
          end

          if inv.date != enspiral_invoice.date
            enspiral_invoice.date = inv.date
          end

          if inv.due_date != enspiral_invoice.due
            enspiral_invoice.due = inv.due_date
          end

          if enspiral_invoice.allocations.count > 0
            enspiral_invoice.allocations.destroy_all
          end

          if inv.line_items.count > 0
            # Invoice.check_discount_value_in_line_item inv, enspiral_invoice
            Invoice.import_line_items inv, enspiral_invoice
          end

          enspiral_invoice.save!

          if inv.status == "VOIDED"
            enspiral_invoice.destroy
          end
        end
      end
    end
  end

  def self.insert_new_invoice invoices
    imported_count = 0
    invoices_count = 0
    invoices.each do |inv|
      invoices_count = invoices_count + 1
      if invoices_count > 30
        puts "sleeping ....."
        sleep(60)
        puts "wake up !"
        invoices_count = 0
      end
      company_id = Company.find_by_name("#{APP_CONFIG[:organization_full]}").id
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
      amount = inv.attributes[:sub_total]
      date = inv.date
      currency = inv.currency_code
      due_date = inv.due_date
      if inv.status == "AUTHORISED" || inv.status == "PAID"
        valid_status = true
      else
        valid_status = false
      end
      xero_link = "https://go.xero.com/AccountsReceivable/View.aspx?InvoiceID=#{inv.invoice_id}"
      if xero_ref && customer && amount && date && due_date && valid_status
        if !Invoice.find_by_xero_reference_and_customer_id(xero_ref, customer.id)
          if !Invoice.find_by_xero_reference(xero_ref)
            saved_invoice = Invoice.create(:customer_id => customer.id, 
                                            :amount => amount, :date => date, 
                                            :due => due_date, :xero_reference => xero_ref, 
                                            :company_id => company_id, :approved => false, 
                                            :currency => currency, :imported => true, 
                                            :xero_link => xero_link)

            if inv.line_items.count > 0
              discount_existed = Invoice.check_discount_value_in_line_item inv
              if discount_existed
                Invoice.import_discount_line_items inv, saved_invoice if saved_invoice
              else
                Invoice.import_line_items inv, saved_invoice if saved_invoice
              end
            end
          end
        end
      end
    end

    if Invoice.where(:imported => true).count > 1
      invoices = Invoice.where(:imported => true)
      invoices.each_with_index do |inv, i|
        if i > 1
          inv.imported = false
          inv.save
        end
      end
    end
  end

  def reconcile!
    self.paid = true
    self.save!
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
