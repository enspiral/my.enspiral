Given /^there are multiple invoices, customers and people$/ do
  Given "#{rand(10) + 2} invoices exist"
  Given "#{rand(10) + 2} customers exist"
  Given "#{rand(10) + 2} people exist"
end
