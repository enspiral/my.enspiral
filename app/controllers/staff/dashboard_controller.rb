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

  def transactions
    transactions = Transaction.transactions_with_totals(current_person.account.transactions)
    

    transactions.map! do |t, balance|
      {
        :id          => t.id,
        :account_id  => t.account_id,
        :creator_id  => t.creator_id,
        :amount      => t.amount,
        :description => t.description,
        :date        => t.date,
        :created_at  => t.created_at,
        :updated_at  => t.updated_at,
        :balance     => balance
      } 
    end

    render :json => transactions
  end

  def balances
    transactions = Transaction.transactions_with_totals(current_person.account.transactions)
    balances = transactions.map { |t, b| { :x => t.created_at.to_i, :y => b } } 
    render :json => balances
  end
end
