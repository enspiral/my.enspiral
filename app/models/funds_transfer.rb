class FundsTransfer < ActiveRecord::Base
  attr_accessible :amount, :description, :destination_account_id, :source_account_id
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
  validate :author_is_source_account_owner
  before_create :create_transactions

  private
  def create_transactions
    self.source_transaction = Transaction.create!(
      creator: author,
      account: source_account,
      amount: (0 - amount),
      date: Date.today,
      description: description)

    self.destination_transaction = Transaction.create!(
      creator: author,
      account: destination_account,
      amount: amount,
      date: Date.today,
      description: description)
  end

  def author_is_source_account_owner
    if source_account
      unless source_account.owners.include? author
        errors.add(:source_account, 'author must be source account owner')
      end
    end
  end
end
