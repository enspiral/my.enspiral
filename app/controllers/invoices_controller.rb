class InvoicesController < IntranetController
  before_filter :load_invoice, only: [:edit, :show, :update, :destroy, :pay]

  def index
    @invoices = @company.invoices.order('created_at DESC').unpaid
  end

  def old
    @invoices = @company.invoices.order('created_at DESC').paid
    render :index
  end

  def new
    @invoice = Invoice.new
  end

  def edit
  end

  def create
    @invoice = @company.invoices.build(params[:invoice])
    if @invoice.save
      redirect_to [@company, @invoice]
    else
      render :new
    end
  end

  def update
    @invoice.update_attributes(params[:invoice])
    if @invoice.save
      redirect_to [@company, @invoice]
    else
      render :edit
    end
  end

  def show
    @payment = Payment.new
    @invoice_allocation = InvoiceAllocation.new(:invoice_id => @invoice.id)
  end

  def pay
    if @invoice.mark_as_paid(current_person)
      flash[:notice] = "Invoice paid"
    else
      flash[:error] = "Could not pay invoice"
    end
    
    redirect_to [@company, @invoice]
  end

  def destroy
    @invoice = @company.invoices.find(params[:id])
    if @invoice.destroy
      flash[:notice] = "Invoice destroyed"
    else
      flash[:error] = "Could not destroy invoice"
    end
    redirect_to company_invoices_path(@company)
  end

  private
  def load_invoice
    @invoice = @company.invoices.where(id: params[:id]).first
    unless @invoice
      flash[:notice] = 'invoice not found'
      redirect_to company_invoices_path(@company)
    end
  end

end
