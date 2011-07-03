class Admin::TransactionsController < Admin::Base
  def index
    @transactions = Transaction.transactions_with_totals(Transaction.order('date DESC, amount DESC'))
    @transactions.sort!{|a,b| b[0].date <=> a[0].date}
    @pending_total = sum_allocations(InvoiceAllocation.pending)
  end

  def balances
    if current_user.admin?
      person = Person.find(params[:person_id])
    else
      person = current_person
    end

    transactions = Transaction.transactions_with_totals(person.account.transactions)
    transactions = transactions[0..(params[:limit].to_i - 1)] if params[:limit]

    balances = transactions.map { |t, b| [(t.created_at.to_i * 1000).to_s, b.to_s] } 
    render :json => balances
  end

  private

  def sum_allocations(allocations)
    allocations.inject(0) {|total, allocation| total += allocation.amount}
  end
end
