class FundsTransferTemplate < ActiveRecord::Base
  attr_accessible :description, :name, :company
  belongs_to :company
  has_many :lines, class_name: 'FundsTransferTemplateLine'
  validates_presence_of :company

  def generate_funds_transfers(options)
    author = options[:author]
    transfers = []
    FundsTransfer.transaction do
      lines.each do |line|
        transfer = FundsTransfer.create(
          destination_account: line.destination_account,
          source_account: line.source_account,
          amount: line.amount,
          description: description,
          author: author)
        raise ActiveRecord::Rollback unless transfer.valid?
        transfers << transfer
      end
    end
    transfers
  end
end
