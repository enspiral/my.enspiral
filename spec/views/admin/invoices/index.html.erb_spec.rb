require 'spec_helper'

describe "/admin/invoices/index" do

  before(:each) do
    assigns[:invoices] = []
  end

  it "should link to the new invoice form" do
    render 'admin/invoices/index'
    response.should have_selector("a", :href => new_admin_invoice_path)
  end

  it "should list multiple invoices" do
    invoice = mock_model(Invoice).as_null_object
    assigns[:invoices] = [invoice, invoice, invoice]
    render 'admin/invoices/index'

    response.should have_selector(".invoices .invoice:nth-child(3)")
  end
end
