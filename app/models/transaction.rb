class Transaction < ActiveRecord::Base
  default_scope order('date DESC, amount DESC')
  belongs_to :account
  belongs_to :creator, :class_name => 'Person'

  validates_presence_of :amount, :account, :description, :date
  validate :will_not_overdraw_account

  after_create :update_account
  after_destroy :update_account

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

  def will_not_overdraw_account
    if (account.balance + amount) < account.min_balance
      errors.add(:amount, 'This transaction will overdraw the account')
    end
  end

  def update_account
    account.calculate_balance
  end
end
