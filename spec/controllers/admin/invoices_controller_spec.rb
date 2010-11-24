require 'spec_helper'

describe Admin::InvoicesController do
  setup :activate_authlogic
  
  before(:each) do
    login_as User.make(:admin)
  end

  #Delete these examples and add some real ones
  it "should use Admin::InvoicesController" do
    controller.should be_an_instance_of(Admin::InvoicesController)
  end

  before(:each) do
    @invoice = mock_model(Invoice, :save => nil).as_null_object
    Invoice.stub(:new).and_return @invoice
  end

  describe "GET 'new'" do
    before(:each) { get 'new' }

    it "should be successful" do
      response.should be_success
    end

    it "should assign an invoice" do
      assigns(:invoice).should be_an_instance_of(Invoice)
    end
  end

  describe "POST 'create'" do
    it "should redirect to show on success" do
      @invoice.should_receive(:save).and_return(true)
      post :create
      response.should redirect_to(admin_invoice_path(assigns(:invoice)))
    end

    it "should render new on failure" do
      @invoice.should_receive(:save).and_return(false)
      post :create
      response.should be_success
      response.should_not be_redirect
    end

  end

  describe "GET 'index'" do
    before(:each) do
      get 'index'
    end
    it "should be successful" do
      response.should be_success
    end

    it "should assign invoices" do
      assigns[:invoices].should_not be_nil
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @invoice = mock_model(Invoice)
      Invoice.stub(:find).and_return @invoice
      get :show
    end

    it "should assign an invoice" do
      assigns(:invoice).should == @invoice
    end
    it "should assign an invoice allocation" do
      assigns(:invoice_allocation).should be_an_instance_of(InvoiceAllocation)
    end
  end

  describe "Post 'pay'" do
    it "should mark an invoice as paid" do
      invoice = Invoice.make
      Invoice.stub(:find).and_return invoice
      invoice.paid.should_not be_false

      post :pay, :id => invoice.id

      invoice.paid.should be_true
      response.should redirect_to(admin_invoice_path(invoice))
    end
  end
end
