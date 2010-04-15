require 'spec_helper'

describe "/admin/invoices/show" do
  before(:each) do
    @invoice = Invoice.make(:paid => false)
    @staff = Person.make
    assigns[:invoice] = @invoice
    assigns[:invoice_allocation] = InvoiceAllocation.new(:invoice_id => @invoice.id)
    render 'admin/invoices/show'
  end

  it "should show the invoice customer" do
    response.should contain(@invoice.customer.name)
  end

  it "should show the invoice total"  do
    response.should contain(number_to_currency(@invoice.amount))
  end

  describe "add allocation to staff" do
    it "should show a form" do
      response.should have_selector('form', :action => admin_invoice_allocations_path)
    end

    it "should have a hidden id for the invoice" do
      response.should have_selector('#new_invoice_allocation input', 
                        :type => 'hidden', 
                        :id => 'invoice_allocation_invoice_id', 
                        :value => @invoice.id.to_s)
    end

    it "should have an amount field" do
      response.should have_selector('#new_invoice_allocation input', 
                        :type => 'text', 
                        :id => 'invoice_allocation_amount'
      )
    end

    it "should have a staff select " do
      response.should have_selector("#new_invoice_allocation select",
                        :id => 'invoice_allocation_person_id'
      )
    end

    it "should have staff in the select box" do
      response.should have_selector("#new_invoice_allocation select option",
                        :content => @staff.name
      )
    end

    it "should have an allocate button" do
      response.should have_selector('#new_invoice_allocation input',
                        :type => 'submit',
                        :value => 'Allocate')
    end
  end

end
