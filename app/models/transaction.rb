class Transaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :creator, :class_name => 'Person'

  validates_presence_of :amount, :account_id, :description, :date

  after_create :update_account
  after_destroy :update_account


  private
  def update_account
    account.calculate_balance
  end
end
