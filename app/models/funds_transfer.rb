class FundsTransfer < ActiveRecord::Base
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  attr_accessible :amount,
                  :date,
                  :reconciled,
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
  has_one    :external_transaction

  validates_presence_of :destination_account,
                        :source_account,
                        :date,
                        :amount,
                        :author,
                        :description

  validates :amount, :numericality => { :greater_than => 0}

  validate :source_account_has_sufficient_funds_or_overdraft
  validates_associated :source_transaction, message: 'Source transaction invalid.'
  validates_associated :destination_transaction
  validate :within_same_company
  validate :source_and_destination_account_identical

  before_validation :build_transactions
  after_update :update_transactions

  attr_accessor :source_description
  attr_accessor :destination_description

  private
  def build_transactions
    return if id
    if amount.nil?
      errors.add(:amount, 'amount is required')
      return
    end

    self.date ||= Date.current
    self.build_source_transaction(
      creator: author,
      account: source_account,
      amount: (0 - amount),
      date: today_in_zone(source_account.company),
      description: (source_description || description))

    self.build_destination_transaction(
      creator: author,
      account: destination_account,
      amount: amount,
      date: today_in_zone(destination_account.company),
      description: (destination_description || description))
  end

  def update_transactions
    source_transaction.amount = (0 - amount)
    source_transaction.account = source_account
    source_transaction.date = date

    destination_transaction.amount = amount
    destination_transaction.account = destination_account
    destination_transaction.date = date

    if source_transaction.changed?
      source_transaction.save!
    end
    if destination_transaction.changed?
      destination_transaction.save!
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

  def source_account_has_sufficient_funds_or_overdraft
    return unless source_account
    maximum_transferrable = source_account.balance - source_account.min_balance
    difference = maximum_transferrable - amount
    # should fail if this is negative

    if difference < 0
      errors.add(:source_account, "'#{source_account.name}' has minimum balance of #{number_to_currency(source_account.min_balance)}. This transfer would exceed what they can draw by #{number_to_currency(difference)}")
    end
  end
end
