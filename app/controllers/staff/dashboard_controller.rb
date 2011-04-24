class Staff::DashboardController < Staff::Base
  def dashboard
    @latest_badge = BadgeOwnership.last
    @person = current_person

    @recent_transactions = @person.account.transactions_with_totals[0..4]
    @invoice_allocations = @person.invoice_allocations.pending
  end

  def transactions
    @transactions = current_person.account.transactions_with_totals
  end
end
