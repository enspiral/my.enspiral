module Enspiral
  module MoneyTree
    class FundsTransferTemplate < ActiveRecord::Base
      attr_accessible :description, :name, :company, :lines_attributes
      belongs_to :company
      has_many :lines, class_name: 'FundsTransferTemplateLine'
      accepts_nested_attributes_for :lines, :reject_if => :all_blank, :allow_destroy => true
      validates_presence_of :company
      validates_associated :lines

      def generate_funds_transfers(options)
        author = options[:author]
        transfers = []
        errors = []
        FundsTransfer.transaction do
          lines.each do |line|
            transfer = FundsTransfer.create(
              destination_account: line.destination_account,
              source_account: line.source_account,
              amount: line.amount,
              description: description,
              author: author)
            transfers << transfer
          end
          transfers.each do |transfer|
            raise ActiveRecord::Rollback unless transfer.valid?
          end
        end
        transfers
      end
    end
  end
end