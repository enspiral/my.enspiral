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
                        :author

  validates_presence_of :description,
    unless: '@source_description.present? and @destination_description.present?'
  validates :amount, :numericality => { :greater_than => 0}

  validates_associated :source_transaction, message: 'Source transaction invalid. This is probably because the account would be overdrawn after this transaction'
  validates_associated :destination_transaction
  validate :within_same_company

  before_validation :build_transactions

  attr_accessor :source_description
  attr_accessor :destination_description

  private
  def build_transactions
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

  def within_same_company
    if source_account and destination_account
      if source_account.company != destination_account.company
        errors.add(:destination_account, 'does not belong to the same company as the source account')
      end
    end
  end
end
