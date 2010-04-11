def user
  @user ||= User.make
end

def admin_user
  @admin_user ||= User.make(:admin)
end

def login(user)
  visit login_url
  fill_in("Email", :with => user.email)
  fill_in("Password", :with => user.password)
  click_button("Log in")
end

def logout
  visit logout_url
end

Given /^I am a logged in user$/ do
  login(user)
end

Given /^I am logged in as an admin$/ do
  login(admin_user)
end

Given /^I am not logged in$/ do
  logout
end

