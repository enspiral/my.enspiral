Given /^I am logged in$/ do
  visit login_path
  fill_in "user_email", :with => @user.email
  fill_in "user_password", :with => "password"
  click_on "Log in"
end

