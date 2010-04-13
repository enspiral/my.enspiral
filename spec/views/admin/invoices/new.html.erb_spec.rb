require 'spec_helper'

describe "/admin/invoices/new" do
  before(:each) do
    Customer.make(:name => "IOSS")
    assigns[:invoice] = Invoice.new
    render 
  end

  it "should have a form for new invoice" do
    response.should have_selector("form" ,
      :method => "post" ,
      :action => admin_invoices_path
    )
  end

  it "should have an amount field" do
    response.should have_selector("input", :id => 'invoice_amount')
  end

  it "should have a customer select" do
    response.should have_selector("select", :id => 'invoice_customer_id')
  end

  it "should have an option for customer" do
    response.should have_selector("select option", :content => "IOSS")
  end

  it "should have a save button" do
    response.should have_selector("input", :type => "submit")
  end

end
