class Account < ActiveRecord::Base
  CATEGORIES = %w[personal project company]
  attr_accessible :name, :description, :public, :min_balance, :closed, :accounts_people_attributes, :expense, :category, :account_type_id
  has_one :project
  default_scope order('name')

  scope :public, where(public: true)
  scope :not_closed, where(closed: false)
  scope :closed, where(closed: true)
  scope :not_expense, where(expense: false)
  scope :expense, where(expense: true)

  has_many :transactions
  has_many :accounts_people
  has_many :people, through: :accounts_people
  belongs_to :company
  belongs_to :account_type
  has_many :invoice_allocations

  accepts_nested_attributes_for :accounts_people, reject_if: :all_blank, allow_destroy: true

  before_validation :calculate_balance

  validates_presence_of :company
  validates_inclusion_of :category, in: CATEGORIES
  validate :account_is_empty_if_closed


  after_initialize do
    self.category ||= 'personal'
  end

  def self.balances_at company, date
    accounts = []
    company.accounts.not_expense.each do |a|
      balance = a.balance_at(date)
      accounts << a if balance != 0
    end
    accounts
  end

  def balance_at date
    self[:balance] = transactions.where("date <= ?", date).sum('amount')
  end

  def positive?
    balance >= 0
  end

  def negative?
    balance < 0
  end

  def reverse_payment amount
    self.transactions.create!(amount: -amount, description: "reverse payment from account #{self.name}", date: Date.today)
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

  def pending_balance
    amount_pending = 0
    invoice_allocations.each do |ia|
      #changeme to get rid of the inline maths, note that contribution_amount is only set for invoices creatd after June 2012
      amount_pending += ia.amount_owing * (1 - ia.contribution)
    end
    amount_pending
  end

  def self.get_team_contribution_reports type, from, to
    type = "Collective Funds" unless type
    team = Account.find_by_name(type)
    contributions = []
    payments = Payment.where(:paid_on => from.to_date-1..to.to_date+1)
    payments = payments.where("contribution_funds_transfer_id IS NOT NULL")
    payments.each do |pay|
      al = pay.invoice_allocation
      account = al.account.name
      amount = 0
      if al.team_account_id == team.id
        amount = (al.amount * al.contribution) * (1.0/8.0)
      end
      tmp = {account => amount}
      contributions << tmp
    end

    if contributions.count > 0
      contributions = contributions.inject{|memo, el| memo.merge( el ){|k, old_v, new_v| old_v + new_v}}
    end
    contributions.each do |key, value|
      contributions.except!(key) if value == 0
    end
    contributions
  end

  def self.get_contribution_reports from,to
    contributions = []
    payments = Payment.where(:paid_on => from.to_date-1..to.to_date+1)
    payments = payments.where("contribution_funds_transfer_id IS NOT NULL")
    payments.each do |pay|
      al = pay.invoice_allocation
      account = al.account.name
      if al.team_account_id.nil?
        amount = al.amount * al.contribution
      else
        amount = (al.amount * al.contribution) * (7.0/8.0)
      end
      tmp = {account => amount}
      contributions << tmp
    end
    
    if contributions.count > 0
      contributions = contributions.inject{|memo, el| memo.merge( el ){|k, old_v, new_v| old_v + new_v}}
    end

    contributions.each do |key, value|
      contributions.except!(key) if value == 0
    end
    contributions
  end

  private
  def account_is_empty_if_closed
    if closed
      errors.add(:closed, "Account balance must be 0 to close.") if balance != 0
    end
  end

end
