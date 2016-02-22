class CompanyMembershipsController < IntranetController
  before_filter :load_membership, only: [:edit, :update, :show, :destroy]
  helper_method :new_path, :new_person_path, :show_path, :edit_path, :index_path

  def new
    @nonmembers = (Person.active.all - @company.people.all)
    @membership = @company.company_memberships.build
  end

  def new_person
    @company = Company.enspiral_services unless @company
    @membership = @company.company_memberships.build
    @membership.build_person
    @membership.person.build_user
  end

  def index
    @memberships = @company.company_memberships.joins(:person).order('people.first_name ASC')
  end

  def create
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

    @membership = @company.company_memberships.build params[:company_membership]

    if @membership.valid? && @membership.person_id.nil?
      person = @membership.person
      if params[:company_membership][:person_attributes][:user_attributes][:password].blank?
        random_pass = 6.times.map{rand(9)}.join
        params[:company_membership][:person_attributes][:user_attributes][:password] = random_pass
        params[:company_membership][:person_attributes][:user_attributes][:password_confirmation] = random_pass
      end
      person.send_welcome params[:company_membership][:person_attributes][:user_attributes]
    end

    if @membership.save
      person = @membership.person
      enspiral_service_company = Company.enspiral_services
      if CompanyMembership.find_by_company_id_and_person_id(enspiral_service_company.id, person.id)
        if @company.name == enspiral_service_company.name
          account = @company.accounts.create!(name: "#{person.name}'s #{@company.name} account")
          account.people << person
          flash[:notice] = "#{person.name} has been added to #{@company.name}, and an account has been created"
        else
          flash[:notice] = "#{person.name} has been added to #{@company.name}"
        end
      else
        account = @company.accounts.create!(name: "#{person.name}'s #{@company.name} account")
        account.people << person
        flash[:notice] = "#{person.name} has been added to #{@company.name}, and an account has been created"
      end
      redirect_to index_path
    else
      @nonmembers = Person.active.where('id not in (?)', @company.people)
      if params[:company_membership] and params[:company_membership][:person_attributes]
        render :new_person
      else
        render :new
      end
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
