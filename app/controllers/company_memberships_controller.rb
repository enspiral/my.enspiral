class CompanyMembershipsController < IntranetController
  before_filter :load_membership, only: [:edit, :update, :show, :destroy]

  def new
    @nonmembers = Person.active.where('id not in (?)', @company.employees)
    @membership = @company.company_memberships.build
  end

  def index
    @memberships = @company.company_memberships
  end

  def create
    @membership = @company.company_memberships.build params[:company_membership]
    if @membership.save
      flash[:notice] = 'Membership created'
      redirect_to company_company_memberships_path @company
    else
      @nonmembers = Person.active.where('id not in (?)', @company.employees)
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @membership.update_attributes(params[:company_membership])
    if @membership.save
      flash[:notice] = 'Membership updated'
      redirect_to company_company_memberships_path @company
    else
      render :edit
    end
  end

  def destroy
    @membership.destroy
    flash[:notice] = 'Membership destroyed'
    redirect_to company_company_memberships_path @company
  end

  private
  def load_membership
    @membership = @company.company_memberships.find params[:id]
  end
end
