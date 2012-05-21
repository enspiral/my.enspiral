def log_in user
  sign_in user
  controller.stub(:authenticate_user!).and_return true
  controller.stub(:authenticate_user?).and_return true
  controller.stub(:current_user).and_return user
  controller.stub(:current_person).and_return user.person
end

def make_invoice_allocation
  make_invoice_allocation_for
end

def make_invoice_allocation_for invoice=nil, person=nil, proportion = 0.75
  invoice ||= Invoice.make!
  person ||= Person.make!
  allocation = InvoiceAllocation.new plan_invoice_allocation_for(invoice, person, proportion)
  allocation.save!
  allocation
end

def plan_invoice_allocation_for invoice, person, proportion = 0.75
  { :invoice => invoice,
    :account => person.account,
    :amount => invoice.amount * proportion,
    :currency => invoice.currency,
    :disbursed => false }
end

def make_financials(person, account)
  InvoiceAllocation.make!(:account => account)
  Transaction.make!(:account => account, :date => Date.parse("2011-02-13"), :amount => 100)
  Transaction.make!(:account => account, :date => Date.parse("2011-02-14"), :amount => -100)
  Transaction.make!(:account => account, :date => Date.parse("2011-02-15"), :amount => 0)
end

def make_test_financials
  @person_1 = Person.make!(:first_name => "Bbbb1")
  @person_2 = Person.make!(:first_name => "Aaaa2")
  @person_3 = Person.make!(:first_name => "Cccc3")

  @account_1 = @person_1.account
  @account_2 = @person_2.account
  @account_3 = @person_3.account

  InvoiceAllocation.make!(:account => @account_1)
  InvoiceAllocation.make!(:account => @account_2)
  InvoiceAllocation.make!(:account => @account_3)

  Transaction.make!(:account => @account_1, :date => Date.parse("2011-02-13"), :amount => 100)
  Transaction.make!(:account => @account_1, :date => Date.parse("2011-02-14"), :amount => 100)
  Transaction.make!(:account => @account_1, :date => Date.parse("2011-02-15"), :amount => 100)

  Transaction.make!(:account => @account_2, :date => Date.parse("2011-02-14"), :amount => -100)
  Transaction.make!(:account => @account_2, :date => Date.parse("2011-02-15"), :amount => 100)
  Transaction.make!(:account => @account_2, :date => Date.parse("2011-02-16"), :amount => -100)

  Transaction.make!(:account => @account_3, :date => Date.parse("2011-02-13"), :amount => -100)
  Transaction.make!(:account => @account_3, :date => Date.parse("2011-02-13"), :amount => -100)
  Transaction.make!(:account => @account_3, :date => Date.parse("2011-02-15"), :amount => -100)
end
