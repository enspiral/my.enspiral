class CustomersController < IntranetController
  before_filter :load_customer, only: [:edit, :show, :update, :destroy, :approve]

  def index
    @customers = @company.customers
    @pending_customers = @customers.unapproved
  end

  def new
    @customer = Customer.new
  end

  def edit
  end

  def create
    @customer = Customer.create(params[:customer])
    if @customer.save
      redirect_to @customer , :notice => 'Customer was successfully created.'
    else
      render :new
    end
  end

  def update
    if @customer.update_attributes(params[:customer])
      redirect_to @customer, :notice => 'Customer was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def approve
    unless @customer.approved?
      @customer.approve!
      if @company
        redirect_to company_invoices_path(@company), notice: 'Customer has been successfuly approved'
      else
        redirect_to company_customers_path(@customer.company), notice: 'Customer has been successfuly approved'
      end
    else
      if @company
        redirect_to company_invoices_path(@company), notice: 'Customer has been successfuly approved'
      else
        redirect_to company_customers_path(@customer.company), alert: 'Customer already approved'
      end
    end
  end

  def pending
    @customers = Customer.where(company_id: current_person.company_ids).unapproved
    @pending_customers = Customer.where(company_id: current_person.company_ids).unapproved
    render :index
  end

  def destroy
    @customer.destroy
    flash[:notice] = 'Destroyed customer!'
    redirect_to company_customers_path(@customer.company)
  end

  def load_customer
    @customer = Customer.where(company_id: current_person.company_ids, id: params[:id]).first
    unless @customer
      flash[:notice] = 'Customer not found'
      redirect_to :back
    end
  end
end
