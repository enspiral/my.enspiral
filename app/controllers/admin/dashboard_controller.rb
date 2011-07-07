class Admin::DashboardController < Admin::Base
  def dashboard 
    @peoples_account_data = []
    @enspiral_pending_total = 0
    @enspiral_balance = 0

    Person.active.order("first_name asc").each do |person|
      @peoples_account_data << {
        :person              => person,
        :transactions        => Transaction.transactions_with_totals(person.account.transactions),
        :invoice_allocations => person.invoice_allocations.pending,
        :pending_total       => person.pending_total
      }

      @enspiral_pending_total += person.pending_total
      @enspiral_balance += person.account.balance
    end
  end

  def enspiral_balances
    transactions = Transaction.transactions_with_totals(Transaction.all)

    balances = transactions.map { |t, b| [(t.date.to_time.to_i * 1000).to_s, b.to_s] } 
    render :json => balances
  end
end
