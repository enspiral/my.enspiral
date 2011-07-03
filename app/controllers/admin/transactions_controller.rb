class Admin::TransactionsController < Admin::Base
  def index
    @transactions = Transaction.transactions_with_totals(Transaction.order('date DESC, amount DESC'))
    @transactions.sort!{|a,b| b[0].date <=> a[0].date}
    @pending_total = sum_allocations(InvoiceAllocation.pending)
  end

  private

  def sum_allocations(allocations)
    allocations.inject(0) {|total, allocation| total += allocation.amount}
  end
end
