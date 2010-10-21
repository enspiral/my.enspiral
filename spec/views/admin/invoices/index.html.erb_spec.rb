require 'spec_helper'

describe "/admin/invoices/index" do

  before(:each) do
    @invoices = []
    assigns[:invoices] = @invoices
  end

  it "should link to the new invoice form" do
    render
    rendered.should have_selector("a", :href => new_admin_invoice_path)
  end

  it "should list multiple invoices" do
    invoice = mock_model(Invoice).as_null_object
    invoice.stub(:amount).and_return 23
    @invoices = [invoice, invoice, invoice]
    assigns[:invoices] = @invoices
    render

    rendered.should have_selector(".invoices .invoice:nth-child(3)")
  end
end
