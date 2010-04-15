require 'spec_helper'

describe "/admin/people/new_transaction" do
  it "should render" do
    assigns[:person] = @person = Person.make
    assigns[:transaction] = @transaction = @person.account.transactions.build
    render '/admin/people/new_transaction'
  end
end
