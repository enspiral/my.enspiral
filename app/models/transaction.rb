class Transaction < ActiveRecord::Base
  default_scope order('id, date DESC')
  belongs_to :account
  belongs_to :creator, :class_name => 'Person'

  validates_presence_of :amount, :account, :description, :date
  validate :will_not_overdraw_account
  validate :account_is_not_closed

  after_create {account.save}
  after_destroy {account.save}
  after_update :update_account 

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

  def update_account 
    account.save!
    if attribute_changed? "account_id"
      Account.find(attribute_was("account_id")).save!
    end
  end

  def will_not_overdraw_account
    return unless account
    if (!amount.nil?) and ((account.balance + amount) < account.min_balance)
      errors.add(:amount, 'This transaction will overdraw the account')
    end
  end

  def account_is_not_closed
    return unless account
    errors.add(:account, 'This account is closed') if account.closed?
  end
end
