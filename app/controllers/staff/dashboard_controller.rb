class Staff::DashboardController < Staff::Base
  def dashboard
    @person = current_person

    @latest_badge = BadgeOwnership.last
    @current_user_goals = Goal.where("person_id = ? AND date >= ?", current_user.person.id, Time.now - 1.days)
    @transactions = Transaction.transactions_with_totals(@person.account.transactions)[0..9] if @person.account
    @invoice_allocations = @person.invoice_allocations.pending
    @pending_total = @person.pending_total
  end

  def history
    @person = current_person
    
    @transactions = Transaction.transactions_with_totals(current_person.account.transactions)
    @pending_total = current_person.pending_total
  end
end

