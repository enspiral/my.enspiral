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
    totalled_transactions = []
    total = 0

    transactions.reverse.each do |transaction|
      if total == 0
        total = transaction.amount
      else
        total += transaction.amount
      end

      totalled_transactions << [transaction, total]
    end

   totalled_transactions.reverse!
  end

end
