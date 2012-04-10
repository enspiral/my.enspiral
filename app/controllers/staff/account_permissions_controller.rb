class Staff::AccountPermissionsController < Staff::Base
  before_filter :require_account_owner
  def index
    @account_permissions = @account.account_permissions
    @account_permission = AccountPermission.new
  end

  def create
    @account.owners << p = Person.find(params[:account_permission][:person_id])
    flash[:notice] = "#{p.name} added to acount owners"
    redirect_to staff_account_permissions_path(@account)
  end

  def destroy
    @permission = @account.account_permissions.
      where(:id => params[:id]).first
    @permission.destroy
    flash[:notice] = "#{@permission.person.name} removed from account owners"
    redirect_to staff_account_permissions_path(@account)
  end

  protected
  def require_account_owner
    if current_user.admin?
      scope = Account
    else
      scope = current_person.accounts
    end

    @account = scope.where(:id => params[:account_id]).first
    unless @account
      flash[:alert] = 'You are not an owner of the account'
      redirect_to staff_path
    end
  end
end
