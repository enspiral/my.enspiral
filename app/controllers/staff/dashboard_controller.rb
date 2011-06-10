class Staff::DashboardController < Staff::Base
  def dashboard
    @person = current_person

    @latest_badge = BadgeOwnership.last
    @transactions = Transaction.transactions_with_totals(@person.account.transactions)[0..9] if @person.account
    @invoice_allocations = @person.invoice_allocations.pending
    @pending_total = @person.pending_total
  end

  def history
    @transactions = Transaction.transactions_with_totals(current_person.account.transactions)
    @pending_total = current_person.pending_total
  end

  def balances
    transactions = Transaction.transactions_with_totals(current_person.account.transactions)
    transactions = transactions[0..(params[:limit].to_i - 1)] if params[:limit]

    balances = transactions.map { |t, b| [(t.created_at.to_i * 1000).to_s, b.to_s] } 
    render :json => balances
  end
end

