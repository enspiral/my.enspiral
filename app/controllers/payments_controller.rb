class PaymentsController < IntranetController
  def create
    @invoice = @company.invoices.find(params[:invoice_id])
    @payment = @invoice.payments.build(params[:payment])
    @payment.author = current_person
    puts @payment.inspect
    if @payment.save
      flash[:notice] = 'Payment Created'
      redirect_to [@company, @invoice]
    else
      @invoice_allocation = InvoiceAllocation.new
      render 'invoices/show'
    end
  end
end
