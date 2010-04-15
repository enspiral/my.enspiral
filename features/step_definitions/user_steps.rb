def new_user
  @staff = make_person
  @user = @staff.user
end

def new_admin_user
  @admin ||= Person.make(:admin)
  @admin_user = @admin.user
end

def login(user)
  @me = user.person
  visit login_url
  fill_in("Email", :with => user.email)
  fill_in("Password", :with => 'secret') #set in blueprints
  click_button("Log in")
end

def logout
  visit logout_url
end

Given /^I am logged in as staff$/ do
  login(new_user)
  response.should contain("Successfully logged in")
end

Given /^I am logged in as an admin$/ do
  login(new_admin_user)
  response.should contain("Successfully logged in")
end

Given /^I am not logged in$/ do
  logout
end

