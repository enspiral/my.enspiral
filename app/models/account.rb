class Account < ActiveRecord::Base
  has_one :project

  scope :active, where(:active => true)
  scope :public, where(:public => true)

  has_many :transactions, :order => "date DESC, amount DESC"
  has_many :account_permissions
  has_many :owners, through: :account_permissions, source: 'person'
  has_many :invoice_allocations

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

end
