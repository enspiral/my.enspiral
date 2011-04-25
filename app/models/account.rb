class Account < ActiveRecord::Base
	belongs_to :person
  has_many :transactions, :order => "date DESC, amount DESC"

  def calculate_balance 
    sum = transactions.sum 'amount'
    update_attribute(:balance, sum)
    sum
  end

  def transactions_with_totals
    return []  if transactions.nil?
    total = 0
    transactions_wt = []

    transactions.reverse.each do |transaction|
      total += transaction.amount
      transactions_wt << [transaction, total]
    end

    transactions_wt.reverse
  end
end
