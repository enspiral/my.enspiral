require 'spec_helper'

describe "/admin/invoices/index" do
  before(:each) do
    render 'admin/invoices/index'
  end

  #Delete this example and add some real ones or delete this file
  it "should link to the new invoice form" do
    response.should have_selector "a", :href => new_admin_invoice_path
  end
end
