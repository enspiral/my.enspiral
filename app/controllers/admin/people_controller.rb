class Admin::PeopleController < Admin::Base
  def index
    @people = Person.active

    @positive_total = 0
    @negative_total = 0
    @balance = @people.inject(0) do |total, p| 
      if p.account.balance > 0
        @positive_total += p.account.balance
      else
        @negative_total += p.account.balance
      end
      total += p.account.balance 
    end
  end

  def show
    @person = Person.find params[:id]
    
    @latest_badge = BadgeOwnership.last
    @transactions = Transaction.transactions_with_totals(@person.account.transactions)[0..9] if @person.account
    @invoice_allocations = @person.invoice_allocations.pending
    @pending_total = @person.pending_total
    
    render :template => 'staff/dashboard/dashboard'
  end

  def new
    @person = Person.new
    @person.user = User.new
  end

  def edit
    @person = Person.find(params[:id])
  end

  def create
    @person = Person.new(params[:person])
    @person.user.email = @person.email
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      redirect_to admin_person_path(@person)
    else
      render :action => "new"
    end
  end

  def update
    @person = Person.find(params[:id])
     
    if (@person != current_person) && !admin_user?
      redirect_to staff_dashboard_url, :error => "You are not authorized to edit this persons profile." and return
    end

    if params[:country].blank?
      country = Country.find_by_id(params[:person][:country_id])
    elsif params[:country]
      country = Country.find_or_create_by_name(params[:country])
    end

    if country
      if params[:city].blank?
        city = country.cities.find_by_id(params[:person][:city_id])
      else
        city = country.cities.find_or_create_by_name(params[:city])
      end

      params[:person].merge! :country_id => country.id
      params[:person].merge! :city_id => city.id if city
    end

    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Details successfully updated.'
        format.html do 
          if current_user.admin?
            redirect_to people_url
          else
            redirect_to staff_dashboard_url
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    redirect_to admin_people_path
  end

  def new_transaction
    @person = Person.find(params[:id])
    @transaction = @person.account.transactions.build 
    @transaction.date = Date.today
  end

  def create_transaction
    @transaction = Transaction.new params[:transaction]
    @person = Person.find(params[:id])

    if @transaction.save
      flash[:notice] = "Transaction added"
      redirect_to admin_person_path(@person)
    else
      flash[:error] = "Could not save transaction" 
      render :new_transaction
    end
  end
end
