class Account < ActiveRecord::Base
  CATEGORIES = %w[personal project company]
  attr_accessible :name, :public, :closed, :accounts_people_attributes, :accounts_companies_attributes
  has_one :project
  default_scope order('name')

  scope :active, where(:active => true)
  scope :public, where(:public => true)

  has_many :transactions, :order => "date DESC, amount DESC"

  has_many :accounts_people
  has_many :people, through: :accounts_people

  has_many :accounts_companies
  has_many :companies, through: :accounts_companies

  has_many :invoice_allocations
  
  validates_inclusion_of :category, in: CATEGORIES
  validate :balance_is_0_before_close

  accepts_nested_attributes_for :accounts_people, :accounts_companies, reject_if: :all_blank, allow_destroy: true
  
  after_initialize do
    self.category ||= 'personal'
  end

  def name
    self[:name] || self.id.to_s
  end

  def calculate_balance
    sum = transactions.sum('amount')
    update_attribute(:balance, sum)
    sum
  end

  def allocated_total
    sum_allocations_less_commission(invoice_allocations)
  end

  def pending_total
    sum_allocations_less_commission(invoice_allocations.pending)
  end

  def disbursed_total
    sum_allocations_less_commission(invoice_allocations.disbursed)
  end

  private
  def sum_allocations_less_commission(allocations)
    allocations.inject(0) {|total,allocation| total += allocation.amount * (1 - allocation.commission)}
  end

  def balance_is_0_before_close
    if closed == true
      calculate_balance
      if balance != 0
        errors.add(:closed, "Account balance must be 0 to close.")
      end
    end
  end

end
