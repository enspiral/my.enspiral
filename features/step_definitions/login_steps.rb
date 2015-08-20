Given /^I am logged in$/ do
  visit login_path
  fill_in "user_email", :with => @user.email
  fill_in "user_password", :with => @user.password
  click_on "Log in"
end
