require 'spec_helper'

describe "/admin/people/new_transaction" do
  it "should render" do
    @person = Person.make
    @person.save!
    assigns[:person] = @person
    assigns[:transaction] = @transaction = @person.account.transactions.build
    render
  end
end
