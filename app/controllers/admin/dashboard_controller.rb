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
    transactions_by_date = {}

    Person.all.each do |person|
      transactions = Transaction.transactions_with_totals(person.account.transactions)

      transactions.each do |transaction, balance|
        date = (transaction.date.to_time.to_i * 1000)

        if transactions_by_date[date].nil?
          transactions_by_date[date] = balance 
        else
          transactions_by_date[date] += balance
        end
      end
    end

    
    transactions_by_date = transactions_by_date.sort
    balances = transactions_by_date.map { |t, b| [t.to_s, b.to_s] } 

    render :json => balances
  end
end
