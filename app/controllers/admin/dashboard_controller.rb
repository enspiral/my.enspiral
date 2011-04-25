class Admin::DashboardController < Admin::Base
  def dashboard 
    @peoples_account_data = []

    Person.active.order("first_name asc").each do |person|
      @peoples_account_data << {
        :person              => person,
        :transactions        => Transaction.transactions_with_totals(person.account.transactions),
        :invoice_allocations => person.invoice_allocations.pending,
        :pending_total       => person.pending_total
      }
    end
  end
end
