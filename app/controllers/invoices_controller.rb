class InvoicesController < IntranetController
  before_filter :load_invoiceable
  before_filter :load_invoice, only: [:edit, :show, :update, :destroy, :close]

  def index
    @invoices = @invoiceable.invoices.not_closed
  end

  def make_payment
  end

  def projects
    if params[:created_begin]
      @created_begin = params[:created_begin].to_date
    else
      @created_begin = 1.month.ago.at_beginning_of_month.to_date
    end
    if params[:created_end]
      @created_end = params[:created_end].to_date
    else
      @created_end = Date.today
    end
    @projects = @company.projects.active.where(created_at: @created_begin..@created_end)
    @total_quoted = 0
    @total_invoiced = 0
    @total_paid = 0
    @projects.each do |p|
      @total_quoted += p.amount_quoted ? p.amount_quoted : 0
      @total_invoiced += p.invoices.sum(:amount)
      @total_paid +=  p.invoices.paid.sum(:amount)
    end
  end


  def closed
    @invoices = @invoiceable.invoices.closed
    render :index
  end

  def new
    if @project
      @invoice = Invoice.new(project_id: @project.id, customer_id: @project.customer.id)
    elsif @customer
      @invoice = Invoice.new(customer_id: @customer.id)
    else
      @invoice = Invoice.new
    end
  end

  def edit
  end

  def close
    unless @invoice.paid?
      @invoice.close!(current_person)
      redirect_to [@invoiceable, :invoices], notice: 'Paid and closed invoice'
    else
      redirect_to [@invoiceable, :invoices], alert: 'invoice already paid'
    end
  end

  def create
    @invoice = @invoiceable.invoices.build(params[:invoice])
    if @invoice.save
      redirect_to [@invoiceable, @invoice]
    else
      render :new
    end
  end

  def update
    if params[:invoice][:payments_attributes]
      params[:invoice][:payments_attributes].each_pair do |key, attrs|
        attrs[:author_id] = current_person.id
      end
    end

    @invoice.update_attributes(params[:invoice])
    if @invoice.save!
      redirect_to [@invoiceable, @invoice]
    else
      #puts "new cash error: " + @invoice.payments.last.new_cash_transaction.errors.inspect
      #puts "renumeration ft error:" + @invoice.payments.last.renumeration_funds_transfer.errors.inspect
      #puts "contribution ft error:" + @invoice.payments.last.contribution_funds_transfer.errors.inspect
      render :edit
    end
  end

  def show
    @payment = Payment.new
  end

  def pay_and_disburse
    @payment = @invoice.payments.create!(amount: @invoice.amount_owing, paid_on: Date.today)
    success = @invoice.disburse!(current_person)

    if success
      flash[:notice] = "Successfully paid and disbused invoice"
    else
      flash[:alert] = 'Unable to disburse'
    end

    redirect_to [@invoiceable, Invoice]
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
    redirect_to [@invoiceable, @invoice]
  end

  def destroy
    if @invoice.destroy
      flash[:notice] = "Invoice destroyed"
    else
      flash[:error] = "Could not destroy invoice"
    end
    redirect_to [@invoiceable, Invoice]
  end

  private
  def load_invoice
    @invoice = @invoiceable.invoices.where(id: params[:id]).first
    unless @invoice
      flash[:notice] = 'invoice not found'
      redirect_to [@invoiceable, Invoice]
    end
  end
  def load_invoiceable
    @invoiceable = (@customer || @project || @company)
  end


end
