class CompaniesController < Staff::Base
  before_filter :load_company_to_admin, :only => [:edit, :update, :show]

  def index
    @admin_companies = current_person.admin_companies
    @companies = current_person.companies
  end

  def show
  end

  def edit
  end

  def update
    @company.update_attributes(params[:company])
    if @company.save
      flash[:notice] = 'Updated Company'
      redirect_to company_path @company
    else
      render :edit
    end
  end

  private
  def load_company_to_admin
    @company = current_person.admin_companies.find(params[:id])
  end

  #def load_company
    #@company = current_person.companies.find(params[:id])
  #end

end
