class Admin::AccountsController < Admin::Base
  def index
    @accounts = Account.all
  end

  def show
    @account = Account.find(params[:id])
  end

end
