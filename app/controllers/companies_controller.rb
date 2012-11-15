class CompaniesController < IntranetController
  def index
    @companies = Enspiral::CompanyNet::Company.all
  end
  def edit
    @company = current_person.admin_companies.find(params[:id])
    unless current_person.admin? or current_person.company_adminships.map{|ca| ca.company_id}.include?(@company.id)
      flash[:error] = "Not for you sunshine!"
      redirect_to admin_companies_url
    end
  end

  def show
    @company = Enspiral::CompanyNet::Company.find(params[:id])
  end

  def update
    @company = current_person.admin_companies.find(params[:id])
    
    if params[:country].blank?
      country = Country.find_by_id(params[:company][:country_id])
    elsif params[:country]
      country = Country.find_or_create_by_name(params[:country])
    end

    if country
      if params[:city].blank?
        city = country.cities.find_by_id(params[:company][:city_id])
      else
        city = country.cities.find_or_create_by_name(params[:city])
      end

      params[:company].merge! :country_id => country.id
      params[:company].merge! :city_id => city.id if city
    end

    if @company.update_attributes(params[:company])
      flash[:success] = 'Profile Updated'
      redirect_to enspiral_company_net_company_path(@company)
    else
      render :edit
    end
  end
end
