require 'spec_helper'

describe Admin::InvoiceAllocationsController do


  #Delete these examples and add some real ones
  it "should use Admin::InvoiceAllocationsController" do
    controller.should be_an_instance_of(Admin::InvoiceAllocationsController)
  end

  describe "creating an invoice allocation" do
    before(:each) do
      customer = Customer.make
      customer.save!
      @invoice = Invoice.make :customer => customer
      @invoice.save!
      @invoice_allocation = mock_model(InvoiceAllocation, :save => true, :invoice => @invoice).as_new_record
      InvoiceAllocation.stub(:new).and_return(@invoice_allocation)
    end

    it "should create an invoice allocation" do
      @invoice_allocation.should_receive(:save)
      post :create
    end

    it "should redirect to invoice" do
      post :create
      response.should redirect_to(admin_invoice_path(@invoice))
    end

    it "should display a flash message when successful" do
      post :create
      flash[:notice].should_not be_empty
      flash[:error].should be_nil
    end

    it "should set an error flash message when unsuccessful" do
      @invoice_allocation.stub(:save).and_return false
      post :create
      flash[:error].should_not be_empty
      flash[:notice].should be_nil
    end
  end

end
