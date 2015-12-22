Given(/^I am admin of a company with unreconciled expenditures$/) do
  @company = Company.make!
  @user = User.make!
  @person = Person.make!(:admin, user: @user)
  @company.people << @person
  @external_account = ExternalAccount.make! company_id: @company.id
  @unreconciled_expenditure = ExternalTransaction.make! external_account_id: @external_account.id,
                                                        external_id: 'abc123'

  @source_account = Account.make! name: 'Source account'
  @source_account.transactions.create(amount: 300, date: 3.days.ago, description: 'test')
  @destination_account = Account.make! name: 'Destination account'
  @company.accounts << @source_account
  @company.accounts << @destination_account
end

When(/^I visit the external accounts page$/) do
  visit company_external_accounts_path(@company)
end

Then(/^I should see a list of the external accounts associated with my company$/) do
  expect(page).to have_content(@external_account.name)
end

When(/^I click the link to view the unreconciled expenditures for an external account$/) do
  first('td > a').click
end

Then(/^I should see a list of unreconciled expenditures$/) do
  expect(page).to have_content(@unreconciled_expenditure.external_id)
end

When(/^I visit the unreconciled expenditures page for an external account$/) do
  visit external_account_external_transactions_path(@external_account)
end

When(/^I click "(.*?)"$/) do |arg1|
  click_on arg1
end

When(/^I fill in and submit the form$/) do
  fill_in 'Description', with: 'Buying something'
  select @source_account.name, from: 'funds_transfer_source_account_id'
  select @destination_account.name, from: 'funds_transfer_destination_account_id'
  click_on 'Submit'
end

Then(/^I should see that the expenditure has been reconciled$/) do
  expect(page).to have_content('Reconciliation successful')
end
