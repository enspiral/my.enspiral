def customers
  @customers ||= {}
end
Given /^a customer named (\w*)$/ do |name|
  customers[name] = Customer.make(:name => name)
end   
