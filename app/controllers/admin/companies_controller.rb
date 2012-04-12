class Admin::CompaniesController < Admin::Base 
  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.create(params[:company])
    @company.admins << current_person
    flash[:notice] = "Created company #{@company.name}"
    redirect_to admin_companies_path
  end

  def destroy
    @company = Company.find params[:id]
    @company.destroy
    flash[:notice] = 'Destroyed Company'
    redirect_to admin_companies_index
  end

end
