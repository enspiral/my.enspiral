class CompanyMembershipsController < IntranetController
  before_filter :load_membership, only: [:edit, :update, :show, :destroy]
  helper_method :new_path, :new_person_path, :show_path, :edit_path, :index_path

  def new
    @nonmembers = (Person.active.all - @company.people.all)
    @membership = @company.company_memberships.build
  end

  def new_person
    @membership = @company.company_memberships.build
    @membership.build_person
    @membership.person.build_user
  end

  def index
    @memberships = @company.company_memberships
  end

  def create
    #@user = User.create! params[:company_membership][:person_attributes][:user_attributes]
    #
    #@person = Person.create! params[:company_membership][:person_attributes]
    @membership = @company.company_memberships.build params[:company_membership]

    if params[:country] and params[:country].blank?
      country = Country.find_by_id(params[:company_membership][:person_attributes][:country_id])
    elsif params[:country]
      country = Country.find_or_create_by_name(params[:country])
    end

    if country
      if params[:city].blank?
        city = country.cities.find_by_id(params[:company_membership][:person_attributes][:city_id])
      else
        city = country.cities.find_or_create_by_name(params[:city])
      end

      params[:company_membership][:person_attributes].merge! :country_id => country.id
      params[:company_membership][:person_attributes].merge! :city_id => city.id if city
    end
    if @membership.save
      flash[:notice] = 'Membership created'
      redirect_to index_path
    else
      @nonmembers = Person.active.where('id not in (?)', @company.people)
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
      redirect_to index_path
    else
      render :edit
    end
  end

  def destroy
    @membership.destroy
    flash[:notice] = 'Membership destroyed'
    redirect_to index_path
  end

  protected
  def new_path
    new_company_company_membership_path(@company)
  end

  def new_person_path
    new_person_company_company_memberships_path(@company)
  end

  def show_path(company_membership)
    company_company_membership_path(@company, company_membership)
  end

  def edit_path(company_membership)
    edit_company_company_membership_path(@company, company_membership)
  end

  def index_path
    company_company_memberships_path @company
  end

  def load_membership
    @membership = @company.company_memberships.find params[:id]
  end
end
