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
    end
  end
end
