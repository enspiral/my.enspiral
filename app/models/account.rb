class Account < ActiveRecord::Base
  CATEGORIES = %w[personal project company]
  attr_accessible :name, :public, :min_balance, :closed, :accounts_people_attributes
  has_one :project
  default_scope order('name')

  scope :public, where(public: true)
  scope :not_closed, where(closed: false)

  has_many :transactions
  has_many :accounts_people
  has_many :people, through: :accounts_people
  belongs_to :company
  has_many :invoice_allocations

  accepts_nested_attributes_for :accounts_people, reject_if: :all_blank, allow_destroy: true

  before_validation :calculate_balance

  validates_presence_of :company
  validates_inclusion_of :category, in: CATEGORIES
  validate :account_is_empty_if_closed


  after_initialize do
    self.category ||= 'personal'
  end

  def positive?
    balance >= 0
  end

  def negative?
    balance < 0
  end

  def balance=(value)
    raise 'You cannot set balance with balance=. Use account.transactions.create or set min_balance depending on your needs'
  end

  def name
    self[:name] || self.id.to_s
  end

  def calculate_balance
    self[:balance] = transactions.sum('amount')
  end

  def allocated_total
    sum_allocations_less_contribution(invoice_allocations)
  end

  def pending_total
    sum_allocations_less_contribution(invoice_allocations.pending)
  end

  def disbursed_total
    sum_allocations_less_contribution(invoice_allocations.disbursed)
  end

  private

  def sum_allocations_less_contribution(allocations)
    allocations.inject(0) {|total,allocation| total += allocation.amount * (1 - allocation.contribution)}
  end

  def account_is_empty_if_closed
    if closed
      errors.add(:closed, "Account balance must be 0 to close.") if balance != 0
    end
  end

end
