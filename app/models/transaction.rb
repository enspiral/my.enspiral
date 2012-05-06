class Transaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :creator, :class_name => 'Person'

  validates_presence_of :amount, :account_id, :description, :date

  after_create :update_account
  after_destroy :update_account
  validate :transaction_allowed

  validates_numericality_of :amount

  def self.transactions_with_totals(transactions)
    return [] if transactions.nil?

    total = 0
    transactions_wt = []

    sorted_transactions = transactions.sort{ |a,b| a.date <=> b.date }

    sorted_transactions.each do |transaction|
      total += transaction.amount
      transactions_wt << [transaction, total]
    end

    transactions_wt.reverse
  end

  private

  def transaction_allowed
    if (self.account.balance + amount) < self.account.min_balance
      errors.add(:amount, "Can't take an account below it's minimum balance.")
    end
  end

  def update_account
    account.calculate_balance
  end
end
