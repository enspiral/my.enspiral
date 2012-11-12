class FundsTransferTemplateLine < ActiveRecord::Base
  belongs_to :destination_account, class_name: 'Enspiral::MoneyTree::Account'
  belongs_to :source_account, class_name: 'Enspiral::MoneyTree::Account'
  belongs_to :funds_transfer_template, inverse_of: :lines
  validates_presence_of :destination_account, :source_account, :amount
end
