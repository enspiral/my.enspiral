class Admin::PeopleController < Admin::Base
  def index
    @people = Person.all
  end

  def show
    @person = Person.find params[:id]
  end

  def new
    @person = Person.new
  end

  def edit
    @person = Person.find(params[:id])
  end

  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      redirect_to admin_person_path(@person)
    else
      render :action => "new"
    end
  end

  def update
    @person = Person.find(params[:id])

    if @person.update_attributes(params[:person])
      flash[:notice] = 'Person was successfully updated.'
      redirect_to admin_person_path(@person)
    else
      render :action => "edit"
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
