require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Service Categories", %q{
  In order to have service categories
  As an admin
  I want to create and manage service categories
} do

  background do
    @admin = User.make!(:admin)
    @person = Person.make!(:user => @admin)
    login_as @admin
  end

  scenario "Service category index" do
    sc1 = ServiceCategory.make!
    sc2 = ServiceCategory.make!
    
    visit service_categories_path
    
    page.should have_content(sc1.name)
    page.should have_content(sc2.name)
  end

  scenario "Add a new service category" do
    new_name = "Awesomeness"
    
    visit service_categories_path
    click_link "New Service Category"
    
    fill_in "service_category_name", :with => new_name
    click_button "Create Service category"
    
    current_path == service_categories_path
    page.should have_content(new_name)
  end

  scenario "Delete a service category" do
    sc = ServiceCategory.make!
    new_name = "Changed"

    visit service_categories_path
    click_link "Destroy"
    
    current_path == service_categories_path
    page.should have_no_content(new_name)
  end

  scenario "Update a service category " do
    sc = ServiceCategory.make!
    new_name = "Changed"

    visit service_categories_path
    click_link "Edit"

    fill_in "service_category_name", :with => new_name
    click_button "Update Service category"
    
    current_path == service_categories_path
    page.should have_content(new_name)
  end
end
