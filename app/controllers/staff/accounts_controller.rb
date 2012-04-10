class Staff::AccountsController < Staff::Base
  before_filter :find_account, :only => [:show, :edit, :update, :balances, :history]

  def index
    @owned = current_person.accounts
    if current_user.admin?
      @all = Account.active
    else
      @public = Account.public
      puts @public.inspect
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
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

  def find_account
    if current_user.admin?
      scope = Account
    else
      scope = current_person.accounts
    end
    @account = scope.find(params[:account_id] || params[:id])
  end


end
