module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    "/"
  end

  def login_path
    "/login"
  end

  def service_categories_path
    "/admin/service_categories"
  end
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
