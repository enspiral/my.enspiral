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

  def new_service_category_path
    "/admin/service_categories/new"
  end

  def edit_service_category_path(id)
    "/admin/service_categories/#{id}/edit"
  end
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
