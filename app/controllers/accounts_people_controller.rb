class AccountsPeopleController < IntranetController
  before_filter :require_account_owner

  def index
    @accounts_people = @account.accounts_people
    @accounts_person = AccountsPerson.new
  end

  def create
    @account.people << p = Person.find(params[:accounts_person][:person_id])
    flash[:notice] = "#{p.name} added to acount owners"

    if @company
      redirect_to company_account_accounts_people_path(@company, @account)
    else
      redirect_to account_accounts_people_path(@account)
    end
  end

  def destroy
    @permission = @account.accounts_people.where(id: params[:id]).first
    @permission.destroy
    flash[:notice] = "#{@permission.person.name} removed from account people"

    if @company
      redirect_to company_account_accounts_people_path(@company, @account)
    else
      redirect_to account_accounts_people_path(@account)
    end
  end

  protected
  def require_account_owner
    if @company
      scope = @company.accounts
    else
      scope = current_person.accounts
    end

    @account = scope.where(:id => params[:account_id]).first
    unless @account
      flash[:alert] = 'You are not an owner of the account'
      redirect_to intranet_path
    end
  end
end
