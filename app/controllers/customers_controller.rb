class CustomersController < IntranetController
  before_filter :load_customer, only: [:edit, :show, :update, :destroy]

  def index
    @customers = @company.customers
  end

  def new
    @customer = Customer.new
  end

  def edit
    
  end

  def create
    @customer = @company.customers.build(params[:customer])
    if @customer.save
      redirect_to(company_customers_path(@company), :notice => 'Customer was successfully created.')
    else
      render :new
    end
  end

  def update
    if @customer.update_attributes(params[:customer])
      redirect_to([@company, @customer], :notice => 'Customer was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @customer.destroy
    flash[:notice] = 'Destroyed customer!'
    redirect_to company_customers_path(@company)
  end

  def load_customer
    @customer = @company.customers.where(id: params[:id]).first
    unless @customer
      flash[:notice] = 'Customer not found'
      redirect_to company_customers_path(@company)
    end
  end
end
