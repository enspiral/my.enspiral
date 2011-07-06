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
  invoice ||= Invoice.make
  person ||= Person.make
  allocation = InvoiceAllocation.new plan_invoice_allocation_for(invoice, person, proportion)
  allocation.save
  allocation
end

def plan_invoice_allocation_for invoice, person, proportion = 0.75
  { :invoice => invoice,
    :person => person,
    :amount => invoice.amount * proportion,
    :currency => invoice.currency,
    :disbursed => false }
end

def make_person(role = nil)
 p = Person.make(role) 
 p.user.person = p
 p
end

