require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Service Categories", %q{
  In order to have service categories
  As an admin
  I want to create and manage service categories
} do

  background do
    @admin = User.make!(:admin)
    current_user = @admin
    login_as @admin
  end

  scenario "Service category index" do
    sc1 = ServiceCategory.make!
    sc2 = ServiceCategory.make!
    visit service_categories_path
    save_and_open_page
    page.should have_content(sc1.name)
    page.should have_content(sc2.name)
  end
end
