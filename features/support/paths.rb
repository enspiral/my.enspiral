module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'

    when /the new invoice page/
      new_admin_invoice_path

    when /my dashboard/
      staff_dashboard_path

    when /the admin dashboard/
      admin_dashboard_path

    when /the invoices page/
      admin_invoices_path

    when /the (\w*)\s*show (\w+) page$/
      prefix = $1
      type = $2
      method = "#{type}_path"
      method = "#{prefix}_#{method}" unless prefix.empty?
      item = eval "@#{type}"
      raise "Could not find item(#{type})" if item.nil?
      eval "path = #{method}(item)" 
      path


    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
