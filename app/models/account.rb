class Account < ActiveRecord::Base
	belongs_to :person
  has_many :transactions, :order => "date DESC, amount DESC"

  def calculate_balance 
    sum = transactions.sum('amount')
    update_attribute(:balance, sum)
    sum
  end
end
