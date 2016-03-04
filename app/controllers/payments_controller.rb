class PaymentsController < IntranetController

  before_filter :load_company, :load_invoice, :load_payment

  def reverse
    if @payment.can_reverse?
      @payment.reverse
    end
    flash[:success] = "Reversed! :D"
    rescue => e
      flash[:notice] = "Transfer failed: #{e.message}"
    ensure
    redirect_to company_invoice_path(@company.id, @invoice.id)
  end

  private

  def load_company
    @company = Company.find(params[:company_id])
  end

  def load_invoice
    @invoice = Invoice.find(params[:invoice_id])
  end

  def load_payment
    @payment = Payment.find(params[:id])
  end

end