Given /^there are (\d*) invoices in the system$/ do |number|
  Invoice.destroy_all
  @invoices = []
  number.to_i.times do
    @invoices << Invoice.make  
  end
end

When /^I create a new invoice worth \$(\d*)$/ do |amount|
  @last_invoice = Invoice.make(:paid => false, :amount => amount)
end

Then /^I should have a new invoice worth \$(\d*)$/ do |amount|
  invoice = @last_invoice || Invoice.last
  invoice.amount.should be_close(amount.to_i, 0.01)
end  



