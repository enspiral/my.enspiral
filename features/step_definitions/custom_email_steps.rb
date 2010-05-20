Then /^(\d+) emails should be sent$/ do |number|
  all_emails.size.should == number
end

