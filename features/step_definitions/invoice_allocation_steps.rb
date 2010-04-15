Given /^I have been allocated \$(\d*) of invoice (\d*)/ do |amount, number|
  invoice = Invoice.find_by_number(number)
  InvoiceAllocation.make(
    :person => @me,
    :invoice => invoice,
    :amount => amount
  )
end

When /^I allocate \$(\d*) to (.*)$/ do |amount, first_name|
  person = staff_with_key first_name
  InvoiceAllocation.make(
    :person => person, 
    :invoice => @last_invoice, 
    :amount => amount
  )
end

Then /^(\w*) should have \$(\d*) allocated$/ do |first_name, amount|
  person = staff_with_key first_name
  person.allocated_total.should be_close(amount.to_i, 0.01)
end

