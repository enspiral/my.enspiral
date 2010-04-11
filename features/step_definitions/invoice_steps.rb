Given /^ther are "([^\"]*)" invoices in the system$/ do |number|
  Invoice.destroy_all
  @invoices = []
  number.to_i.times do
    @invoices << Invoice.make  
  end
end

When /^I create a new invoice worth \$"([^\"]*)"$/ do |amount|
  @last_invoice = Invoice.make(:paid => false, :amount => amount)
end

Then /^"([^\"]*)" should have "([^\"]*)" available$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end




