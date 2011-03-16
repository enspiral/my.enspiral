class Admin::PeopleController < Admin::Base
  def index
    @people = Person.all

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
    render :template => 'staff/dashboard/index'
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
    if request.put?
      country = params[:country].blank? ? Country.find_by_id(params[:person][:country_id]) : Country.find_or_create_by_name(params[:country])
      
      if country.blank?
        params[:person].merge! :country_id => nil, :city_id => nil
      else
        city = params[:city].blank? ? country.cities.find_by_id(params[:person][:city_id]) : country.cities.find_or_create_by_name(params[:city])
        params[:person].merge! :country_id => country.id, :city_id => (city.blank? ? nil : city.id)
      end
      
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Details successfully updated.'
        if current_user.admin?
          redirect_to admin_people_path(@person)
        else
          redirect_to staff_dashboard_url
        end
        return
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
