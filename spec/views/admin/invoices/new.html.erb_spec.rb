require 'spec_helper'

describe "/admin/invoices/new" do
  before(:each) do
    customer = Customer.make(:name => "IOSS")
    customer.save!
    @invoice = Invoice.new
    assigns[:invoice] = @invoice
    render 
  end

  it "should have a form for new invoice" do
    rendered.should have_selector("form" ,
      :method => "post" ,
      :action => admin_invoices_path
    )
  end

  it "should have an amount field" do
    rendered.should have_selector("input", :id => 'invoice_amount')
  end

  it "should have a customer select" do
    rendered.should have_selector("select", :id => 'invoice_customer_id')
  end

  it "should have an option for customer" do
    rendered.should have_selector("select option", :content => "IOSS")
  end

  it "should have a save button" do
    rendered.should have_selector("input", :type => "submit")
  end

end
