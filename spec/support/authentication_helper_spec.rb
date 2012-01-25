module AuthenticationHelper
  def login(user)
    #post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
    visit "/login"

    fill_in "Email",    :with => user.email
    fill_in "Password", :with => user.password

    click_button "Log in"

    page.should have_content('Signed in')
  end
end
