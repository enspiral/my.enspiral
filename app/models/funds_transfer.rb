class FundsTransfer < ActiveRecord::Base
  attr_accessible :amount,
                  :description,
                  :destination_account_id,
                  :source_account_id,
                  :destination_account,
                  :source_account,
                  :author,
                  :source_description,
                  :destination_description

  belongs_to :author, class_name: 'Person'
  belongs_to :source_account, class_name: 'Account'
  belongs_to :destination_account, class_name: 'Account'
  belongs_to :source_transaction, class_name: 'Transaction'
  belongs_to :destination_transaction, class_name: 'Transaction'

  validates_presence_of :destination_account,
                        :source_account,
                        :amount,
                        :author,
                        :description

  validates :amount, :numericality => { :greater_than => 0}

  validates_associated :source_transaction, message: 'Source transaction invalid. This is probably because the account would be overdrawn after this transaction'
  validates_associated :destination_transaction
  validate :within_same_company
  validate :source_and_destination_account_identical

  before_validation :build_transactions
  after_update :update_transactions

  attr_accessor :source_description
  attr_accessor :destination_description

  def date
    source_transaction.date
  end

  private
  def build_transactions
    return if id

    self.build_source_transaction(
      creator: author,
      account: source_account,
      amount: (0 - amount),
      date: Date.today,
      description: (source_description || description))

    self.build_destination_transaction(
      creator: author,
      account: destination_account,
      amount: amount,
      date: Date.today,
      description: (destination_description || description))
  end

  def update_transactions
    source_transaction.amount = (0 - amount)
    source_transaction.account = source_account
    destination_transaction.amount = amount
    destination_transaction.account = destination_account

    if source_transaction.changed?
      source_transaction.save 
    end
    if destination_transaction.changed?
      destination_transaction.save 
    end
  end

  def within_same_company
    if source_account and destination_account
      if source_account.company != destination_account.company
        errors.add(:destination_account, 'does not belong to the same company as the source account')
      end
    end
  end

  def source_and_destination_account_identical
    if source_account == destination_account
      errors.add(:destination_account, 'can not be the same as the source account')
    end
  end
end
