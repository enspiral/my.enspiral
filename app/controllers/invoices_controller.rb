class InvoicesController < IntranetController
  before_filter :load_invoice, only: [:edit, :show, :update, :destroy, :disburse, :pay_and_disburse]

  def index
    @invoices = @company.invoices.not_closed
  end

  def closed
    @invoices = @company.invoices.closed
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

  def pay_and_disburse
    @payment = @invoice.payments.create!(amount: @invoice.amount_owing, paid_on: Date.today)
    success = @invoice.disburse!(current_person)

    if success
      flash[:notice] = "Successfully paid and disbused invoice"
    else
      flash[:alert] = 'Unable to disburse'
    end

    redirect_to company_invoices_path @company
  end

  def disburse
    if params[:invoice_allocation_id]
      @allocation = @invoice.allocations.find params[:invoice_allocation_id]
      type = 'allocation'
      success = @allocation.disburse!(current_person)
    else
      type = 'all allocations'
      success = @invoice.disburse!(current_person)
    end
    if success
      flash[:notice] = "Successfully disbused #{type}"
    else
      flash[:alert] = 'Unable to disburse'
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
