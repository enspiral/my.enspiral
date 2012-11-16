class CustomersController < IntranetController
  before_filter :load_customer, only: [:edit, :show, :update, :destroy]

  def index
    @customers = @company.customers
  end

  def new
    @customer = Enspiral::CompanyNet::Customer.new
  end

  def edit
  end

  def create
    @customer = Enspiral::CompanyNet::Customer.create(params[:customer])
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

  def destroy
    @customer.destroy
    flash[:notice] = 'Destroyed customer!'
    redirect_to enspiral_company_net_company_enspiral_company_net_customers_path(@customer.company)
  end

  def load_customer
    @customer = Enspiral::CompanyNet::Customer.where(company_id: current_person.company_ids, id: params[:id]).first
    unless @customer
      flash[:notice] = 'Customer not found'
      redirect_to :back
    end
  end
end
