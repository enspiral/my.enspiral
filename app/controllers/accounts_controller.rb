class AccountsController < IntranetController
  before_filter :load_account, :only => [:show, :edit, :update, :balances, :history]

  def index
    if @company
      @accounts = @company.accounts
    else
      @accounts = current_person.accounts
    end
  end

  def show
  end

  def balances
    transactions = Transaction.transactions_with_totals(@account.transactions)
    transactions = transactions[0..(params[:limit].to_i - 1)] if params[:limit]
    balances = transactions.map { |t, b| [(t.date.to_time.to_i * 1000).to_s, b.to_s] } 
    render :json => balances
  end

  def history
    @transactions = Transaction.transactions_with_totals(@account.transactions)
    @pending_total = @account.pending_total
  end

  private

  def load_account
    if current_user.admin?
      scope = Account
    elsif @company and @company.admins.include?(current_person)
      scope = @company.accounts
    else
      scope = current_person.accounts
    end
    @account = scope.where(id: params[:id]).first

    unless @account
      flash[:alert] = 'Account not found'
      redirect_to intranet_path
    end
  end


end
