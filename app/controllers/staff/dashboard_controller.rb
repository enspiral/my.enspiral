class Staff::DashboardController < Staff::Base

  def index
    all = current_person.invoice_allocations
    @pending = all.pending || []
    @disbursed = all.disbursed || []

    @transactions_with_totals = []
    transactions = current_person.account.transactions || []
    total = 0

    transactions.reverse.each do |transaction|
      if total == 0
        total = transaction.amount
      else
        total += transaction.amount
      end

      @transactions_with_totals << [transaction, total]
    end

    @transactions_with_totals.reverse!
  end

end
