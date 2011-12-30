class Staff::AccountsController < Staff::Base
  before_filter :find_account, :only => [:show, :edit, :update, :balances, :history]

  def index
    if current_user.admin?
      @accounts = Account.active
    else
      @accounts = Account.active.where("person_id IS NULL OR person_id = #{current_person.id}")
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
    #TODO put auth 
    id = params[:id] || params[:account_id]
    @account = Account.find(id)
  end


end
