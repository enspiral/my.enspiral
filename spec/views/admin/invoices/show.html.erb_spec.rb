require 'spec_helper'

describe "/admin/invoices/show" do

  describe "default invoice" do
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
  describe "control links" do
    before(:each) do
      @invoice = Invoice.make(:paid => false)
      @invoice.stub(:paid => false, :allocated? => false, :unallocated => 0)
      assigns[:invoice] = @invoice
    end
    it "should show destroy for unpaid and unallocated" do
      render 'admin/invoices/show'
      response.should have_selector("a", :content => 'Destroy')
      response.should_not have_selector("a", :content => 'Pay')
    end

    it "should show neither pay or destroy for a paid invoice" do
      @invoice.stub(:paid => true)
      render 'admin/invoices/show'
      response.should_not have_selector("a", :content => 'Destroy')
      response.should_not have_selector("a", :content => 'Pay')
    end

    it "should show pay and not destroy for an allocated invoice" do
      @invoice.stub(:allocated? => true)
      render 'admin/invoices/show'
      response.should_not have_selector("a", :content => 'Destroy')
      response.should have_selector("a", :content => 'Pay')
    end
  end
end
