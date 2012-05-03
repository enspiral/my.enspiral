class AccountsController < IntranetController
  before_filter :load_account, :only => [:show, :edit, :update, :balances, :history, :transactions]

  def index
    if @company
      @accounts = @company.accounts
    else
      @accounts = current_person.accounts
    end
  end

  def new
    @account = Account.new
    if @company
      @account.accounts_companies.build(company: @company)
      @account.category = 'company'
    else
      @account.accounts_people.build(person: current_person)
      @account.category = 'personal'
    end
  end

  def edit
  end

  def update
    #check here for overdraft permissions
    if @account.update_attributes(params[:account])
      flash[:notice] = 'Updated Account'
      redirect_to [@company, @account]
    else
      render :edit
    end
  end

  def create
    @account = Account.create(params[:account])

    if @account.valid?
      flash[:notice] = 'Account created'
      redirect_to [@company, @account]
    else
      render :new
    end
  end

  def show
    @funds_transfer = FundsTransfer.new(source_account_id: @account.id)
    @funds_transfers = FundsTransfer.where('source_account_id = ? OR destination_account_id = ?', @account.id, @account.id).order('created_at DESC')
  end

  def balances
    transactions = Transaction.transactions_with_totals(@account.transactions)
    transactions = transactions[0..(params[:limit].to_i - 1)] if params[:limit]
    balances = transactions.map { |t, b| [(t.date.to_time.to_i * 1000).to_s, b.to_s] } 
    render :json => balances
  end

  def transactions
    @transactions = Transaction.transactions_with_totals(@account.transactions)
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
    @account = scope.where(id: (params[:account_id] || params[:id])).first

    unless @account
      flash[:alert] = 'Account not found'
      redirect_to intranet_path
    end
  end


end
