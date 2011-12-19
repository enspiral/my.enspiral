class Account < ActiveRecord::Base
	belongs_to :person
  belongs_to :project

  validates_uniqueness_of :person_id, :allow_nil => true
  validates_uniqueness_of :project_id, :allow_nil => true

  scope :with_projects, where("project_id IS NOT NULL")
  scope :active, where(:active => true)

  has_many :transactions, :order => "date DESC, amount DESC"
  has_many :account_permissions
  has_many :invoice_allocations

  def calculate_balance 
    sum = transactions.sum('amount')
    update_attribute(:balance, sum)
    sum
  end

  def name
    if read_attribute(:name)
      read_attribute(:name)
    elsif project_id
      "#{project.name}'s Project Account"
    elsif person_id
      "#{person.name}'s Project Account"
    end
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

end
