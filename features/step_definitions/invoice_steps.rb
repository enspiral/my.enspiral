def make_invoice(params = {})
  @last_invoice = Invoice.make(params)
end

#Given /^there are (\d*) invoices in the system$/ do |number|
#  Invoice.destroy_all
#  @invoices = []
#  number.to_i.times do
#    @invoices << Invoice.make  
#  end
#end

Given /^an unpaid invoice numbered (\d*) worth \$(\d*)/ do |number, amount|
  make_invoice(:paid => false, :number => number, :amount => amount)
end

When /^invoice numbered (\d*) is marked as paid$/ do |invoice_number|
  invoice = Invoice.find_by_number(invoice_number)
  invoice.mark_as_paid
end


When /^I create a new invoice worth \$(\d*)$/ do |amount|
  make_invoice(:paid => false, :amount => amount)
end

Then /^I should have a new invoice worth \$(\d*)$/ do |amount|
  invoice = @last_invoice || Invoice.last
  invoice.should_not be_nil
  invoice.amount.should be_close(amount.to_i, 0.01)
end  



