class Admin::InvoicesController < ApplicationController
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
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

end
