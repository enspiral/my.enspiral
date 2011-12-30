class Staff::PeopleController < Staff::Base
  #todo move this somewhere into admin module
  def balances
    if current_user.admin?
      person = Person.find(params[:person_id])
    else
      render nil and return
    end

    transactions = Transaction.transactions_with_totals(person.account.transactions)
    transactions = transactions[0..(params[:limit].to_i - 1)] if params[:limit]

    balances = transactions.map { |t, b| [(t.date.to_time.to_i * 1000).to_s, b.to_s] } 
    render :json => balances
  end
end
