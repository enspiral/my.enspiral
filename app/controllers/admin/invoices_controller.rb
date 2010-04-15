class Admin::InvoicesController < Admin::Base
  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
      redirect_to admin_invoice_path(@invoice)
    else
      render :new
    end
  end

  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_allocation = InvoiceAllocation.new(:invoice_id => @invoice.id)
  end

end
