class Staff::DashboardController < Staff::Base
  def dashboard
    @latest_badge = BadgeOwnership.last
    @person = current_person

    @transactions = @person.account.transactions_with_totals[0..9]
    @invoice_allocations = @person.invoice_allocations.pending
    @pending_total = @person.pending_total
  end

  def history
    @transactions = current_person.account.transactions_with_totals
    @pending_total = current_person.pending_total
  end
end
