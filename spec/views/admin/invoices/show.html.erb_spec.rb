require 'spec_helper'

describe "/admin/invoices/show" do

  describe "default invoice" do
    before(:each) do
      @invoice = Invoice.make! :paid => false
      @staff = Person.make!
      @project = Project.make!
      @invoice_allocation = InvoiceAllocation.make! :invoice => @invoice, :account => @staff.account
      assigns[:invoice] = @invoice
      assigns[:invoice_allocation] = @invoice_allocation
      render
    end

    it "should show the invoice customer" do
      rendered.should contain(@invoice.customer.name)
    end

    it "should show the invoice total"  do
      rendered.should contain(number_to_currency(@invoice.amount))
    end

    describe "add allocation to staff" do
      it "should show a form" do
        rendered.should have_selector('form', :action => admin_invoice_allocations_path)
      end

      it "should have a hidden id for the invoice" do
        rendered.should have_selector('input#invoice_allocation_invoice_id', 
                          :type => 'hidden', 
                          :value => @invoice.id.to_s)
      end

      it "should have an amount field" do
        rendered.should have_selector('input#invoice_allocation_amount', 
                          :type => 'text'
        )
      end

      it "should have a account select " do
        rendered.should have_selector("select#invoice_allocation_account_id")
      end

      it "should have project account in the select box" do
        rendered.should have_selector("select#invoice_allocation_account_id option",
                          :value => @project.account.id.to_s
        )
      end

      it "should have an allocate button" do
        rendered.should have_selector('input#invoice_allocation_submit',
                          :type => 'submit',
                          :value => 'Allocate')
      end
    end
  end

  describe "control links" do
    before(:each) do
      customer = Customer.make
      customer.save!
      @invoice = Invoice.make :customer => customer, :paid => false
      @invoice.save!
      @invoice.stub(:paid => false, :allocated? => false, :unallocated => 0)
      assigns[:invoice] = @invoice
    end
    it "should show destroy for unpaid and unallocated" do
      render
      rendered.should have_selector("input", :type => 'submit', :value => 'Destroy')
      rendered.should_not have_selector("a", :content => 'Pay')
    end

    it "should show neither pay or destroy for a paid invoice" do
      @invoice.stub(:paid => true)
      render
      rendered.should_not have_selector("input", :type => 'submit', :value => 'Destroy')
      rendered.should_not have_selector("a", :content => 'Pay')
    end

    it "should show pay and not destroy for an allocated invoice" do
      @invoice.stub(:allocated? => true)
      render
      rendered.should_not have_selector("a", :content => 'Destroy')
      rendered.should have_selector("a", :content => 'Pay')
    end
    it "should not show delete allocation links when paid" do
      @invoice.stub(:paid => true)
      allocation = mock_model(InvoiceAllocation).as_null_object
      allocation.stub(:amount).and_return 800
      @invoice.stub(:allocations).and_return [allocation,allocation,allocation]
      render
      rendered.should_not have_selector("a", :content => "delete")
    end
  end
end






