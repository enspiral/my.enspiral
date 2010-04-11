When /^I allocate \$(\d*) to (.*)$/ do |amount, first_name|
  person = staff_with_key first_name
  InvoiceAllocation.make(
    :person => person, 
    :invoice => @last_invoice, 
    :amount => amount,
    :currency => @last_invoice.currency,
    :disbursed => true
  )
end

Then /^(\w*) should have \$(\d*) allocated$/ do |first_name, amount|
  person = staff_with_key first_name
  person.allocated.should be_close(amount.to_i, 0.01)
end
