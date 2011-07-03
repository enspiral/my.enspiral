class Staff::PeopleController < Staff::Base
  def funds_transfer
    if request.post?
      @another_person = Person.find params[:person_id]
      @amount = params[:amount].to_f
      
      success = current_person.transfer_funds_to(@another_person, @amount)
      
      if success == true
        flash[:notice] = 'Funds successfully transferred.'
      else
        flash[:error] = success
      end
      redirect_to staff_path
    end
  end

  def balances
    if current_user.admin?
      person = Person.find(params[:person_id])
    else
      person = current_person
    end

    transactions = Transaction.transactions_with_totals(person.account.transactions)
    transactions = transactions[0..(params[:limit].to_i - 1)] if params[:limit]

    balances = transactions.map { |t, b| [(t.date.to_time.to_i * 1000).to_s, b.to_s] } 
    render :json => balances
  end
end
