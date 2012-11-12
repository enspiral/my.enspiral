class AccountsController < IntranetController
  before_filter :load_account, :only => [:show, :edit, :update, :balances, :history, :transactions]
  before_filter :redirect_if_closed, only: [:edit, :update]

  def index
    if @company
      @accounts = @company.accounts.not_closed.not_expense
      @accounts = @accounts.where(category: params[:category]) if params[:category].present?
      #raise @company.accounts.where(category: 'project').inspect
      @title = "#{@company.name} Accounts"
    else
      @accounts = current_person.accounts.not_closed.not_expense
      @title = 'Your Accounts'
    end
  end

  def public
    company_ids = @company ? @company.id : current_person.companies
    @accounts = Enspiral::MoneyTree::Account.not_closed.public.where(company_id: company_ids)
    @title = 'Public Accounts'
    render :index
  end

  def expense
    company_ids = @company ? @company.id : current_person.companies
    @accounts = Enspiral::MoneyTree::Account.not_closed.expense.where(company_id: company_ids)
    @title = 'Input/Output Accounts'
    render :index
  end

  def new
    @account = Enspiral::MoneyTree::Account.new
    @account.accounts_people.build(person: current_person)
    @account.category = 'personal'
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
    @account = Enspiral::MoneyTree::Account.new(params[:account])
    @account.company_id = params[:account][:company_id]

    if @account.save
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

  private

  def redirect_if_closed
    if !current_person.admin? and @account.closed?
      flash[:alert] = "this account is closed and cannot be edited"
      redirect_to [@company, Accounts]
    end
  end

  def load_account
    account_id = (params[:account_id] || params[:id])
    @account_admin = true
    if current_user.admin?
      @account = Enspiral::MoneyTree::Account.find account_id
    elsif @account = Enspiral::MoneyTree::Account.where(company_id: current_person.admin_company_ids, id: account_id).first
    elsif @account = current_person.accounts.where(id: account_id).first
    else
      if %w[show balance history transactions].include? action_name
        @account = Enspiral::MoneyTree::Account.where(public: true, id: params[:id]).first
        @account_admin = false
      end
    end

    unless @account
      flash[:alert] = 'Account not found or action not permitted'
      redirect_to accounts_path
    end
  end


end
