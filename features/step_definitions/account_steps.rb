def account_for person
  person.account || make_account_for_person(person)
end

def make_account_for person
  Account.make(:person => person)
end

Given /^my account balance is \$(\d*)$/ do |balance|
  account = account_for @staff
  account.update_attribute(:balance, balance)
end

Then /^my account balance should be \$(\d*)$/ do |balance|
  @me.account.reload
  @me.account.balance.to_s.should == balance
end

