class Admin::InvoiceAllocationsController < ApplicationController
  def create
    @invoice_allocation = InvoiceAllocation.new(params[:invoice_allocation])
    if @invoice_allocation.save
      flash[:notice] = "Allocation saved"
    else
      flash[:error] = "Error saving allocation"
    end
    redirect_to admin_invoice_path(@invoice_allocation.invoice)
  end

  def destroy
  end

end
