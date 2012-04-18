class ProfilesController < IntranetController
  def edit
    @person = current_person
  end

  def update
    @person = current_person
    
    if @person.update_attributes(params[:person])
      flash[:notice] = 'Profile Updated'
      redirect_to intranet_paht
    else
      render :edit
    end
  end
end
