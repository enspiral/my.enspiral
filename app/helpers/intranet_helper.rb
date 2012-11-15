# Methods added to this helper will be available to all templates in the application.
module IntranetHelper
  def comma_separated_companies companies
    @list = companies.map do |c|
      if current_user.admin?
        link_to c.name, enspiral_company_net_company_company_memberships_path(c)
      else
        c.name
      end
    end
    raw @list.join(', ')
  end

end
