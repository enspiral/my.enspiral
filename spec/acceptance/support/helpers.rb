module HelperMethods
  def log_in_with(user)
    visit "/"
    fill_in "user",     :with => user.login
    fill_in "passowrd", :with => "123456"
    click "login"
  end

  [:notice, :error].each do |name|
    define_method "should_have_#{name}" do |message|
      page.should have_css(".message.#{name}", :text => message)
    end
  end

  def should_be_on(path)
    page.current_url.should match(Regexp.new(path))
  end

  def should_not_be_on(path)
    page.current_url.should_not match(Regexp.new(path))
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
