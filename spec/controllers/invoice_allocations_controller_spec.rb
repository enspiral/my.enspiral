require 'spec_helper'

describe InvoiceAllocationsController do
  describe "creating an invoice allocation" do
    before(:each) do
      @person = Person.make! :staff
      sign_in @person.user
      @invoice = Invoice.make!
      @company = @invoice.company
      CompanyMembership.make! company:@company, person:@person, admin:true
      @invoice_allocation = mock_model(InvoiceAllocation, :save => true, :invoice => @invoice).as_new_record
      InvoiceAllocation.stub(:new).and_return(@invoice_allocation)
    end

    it "should create an invoice allocation" do
      @invoice_allocation.should_receive(:save)
      post :create, company_id: @company.id
      response.should redirect_to(company_invoice_path(@company, @invoice))
      flash[:notice].should_not be_empty
      flash[:error].should be_nil
    end

    it "should set an error flash message when unsuccessful" do
      @invoice_allocation.stub(:save).and_return false
      post :create, company_id: @company.id
      flash[:error].should_not be_empty
      flash[:notice].should be_nil
    end
  end

end
