class Admin::CompaniesController < AdminController
  def index
    @companies = Enspiral::CompanyNet::Company.all
  end

  def new
    @company = Enspiral::CompanyNet::Company.new
  end

  def edit
    @company = Enspiral::CompanyNet::Company.find params[:id]
  end

  def update
    @company = Enspiral::CompanyNet::Company.find params[:id]
    if @company.update_attributes(params[:company])
      redirect_to [:admin, :companies]
    else
      render :edit
    end
  end

  def create
    @company = Enspiral::CompanyNet::Company.create(params[:company])
    @company.admins << current_person
    flash[:notice] = "Created company #{@company.name}"
    redirect_to admin_enspiral_company_net_companies_path
  end

  def destroy
    @company = Enspiral::CompanyNet::Company.find params[:id]
    @company.destroy
    flash[:notice] = 'Destroyed Company'
    redirect_to admin_enspiral_company_net_companies_path
  end

end
