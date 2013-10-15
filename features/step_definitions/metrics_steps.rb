Given /^I am a company admin$/ do
  @company = Company.create!(:name => "WORLD DOMINATION")
  @user = User.create!(:email => "abc@123.com", :password => "password")
  @person = Person.create!(:user => @user, :first_name => "Enspiral",
                           :last_name => "Gnome")
  CompanyMembership.create!(:company => @company, :person => @user.person,
                            :admin => true)
end

Given /^I am not a company admin$/ do
  @company = Company.create!(:name => "WORLD DOMINATION")
  @user = User.create!(:email => "abc@123.com", :password => "password")
  @person = Person.create!(:user => @user, :first_name => "Enspiral",
                           :last_name => "Gnome")
end

When /^I visit the company metrics page$/ do
  visit company_metrics_path(@company)
end

When /^I visit the company create new metric page$/ do
  visit new_company_metric_path(@company)
end

When /^I fill in and submit the new metric form$/ do
  page.select "2012", :from => "metric_for_date_1i"
  page.select "May", :from => "metric_for_date_2i"
  fill_in "metric_external_revenue", :with => "201.45"
  fill_in "metric_internal_revenue", :with => "200"
  fill_in "metric_people", :with => "2"
  fill_in "metric_active_users", :with => "100"
  click_on "Save"
end

Then /^I should be redirected to the company metrics page$/ do
  page.should have_content("WORLD DOMINATION Metrics")
end

Then /^I should see the new metric$/ do
  page.should have_content("201.45")
end

Given /^the company has an existing metric$/ do
  @metric = Metric.create!(:company => @company,
                           :external_revenue => 201.45,
                           :internal_revenue => 200,
                           :date => Date.today,
                           :active_users => 15,
                           :people => 20)
end

When /^I choose to edit the existing metric$/ do
  click_on "edit_metric_#{@metric.id}"
end

When /^I choose to delete the existing metric$/ do
  click_on "delete_metric_#{@metric.id}"
  page.driver.browser.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
end

When /^I edit and submit the existing metric form$/ do
  fill_in "metric_external_revenue", :with => "99.54"
  click_on "Save"
end

Then /^I should see the edited metric$/ do
  page.should have_content(@metric.reload.external_revenue)
end

Then /^I should no longer see the existing metric$/ do
  page.should_not have_content(@metric.external_revenue)
end
