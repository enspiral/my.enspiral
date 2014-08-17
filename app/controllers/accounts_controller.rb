class AccountsController < IntranetController
  before_filter :load_account, :only => [:show, :edit, :update, :balances, :history, :transactions]
  before_filter :redirect_if_closed, only: [:edit, :update]

  def index
    if @company
      # @accounts = @company.accounts.not_closed.not_expense
      @accounts = @company.accounts.not_closed
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
    @accounts = Account.not_closed.public.where(company_id: company_ids)
    @title = 'Public Accounts'
    render :index
  end

  def reopen
    account = Account.find(params[:id])
    if params[:company_id]
      company = Company.find(params[:company_id])
    else
      company = current_person.companies.first
    end
    account.closed = false
    account.save!
    redirect_to company_account_path(company, account)
  end

  def closed
    company_ids = @company ? @company.id : current_person.companies
    @accounts = Account.closed.where(company_id: company_ids)
    @title = 'Closed Accounts'
    render :index
  end

  def external
    company_ids = @company ? @company.id : current_person.companies
    @accounts = Account.not_closed.expense.where(company_id: company_ids)
    @title = 'Input/Output Accounts'
    render :index
  end

  def historic_balances
    redirect_to :index and return if @company.nil?
    @date = params[:date] || Date.today
    @accounts = Account.balances_at @company, @date
    @title = 'Historic balances'
    render :index
  end

  def new
    @account = Account.new
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
    @account = Account.new(params[:account])
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
    @transactions = Transaction.transactions_with_totals(@account.transactions)[0,20]
    @invoice_allocations = @account.invoice_allocations.invoice_paid_on
    # binding.pry
    if params[:commit] == 'Filter' && !params[:to].empty? && !params[:from].empty?
      @from = params[:from].to_date
      @to = params[:to].to_date
      @funds_transfers = @funds_transfers.where("date >= ? and date <= ?", @from, @to)
      @transactions = Transaction.where("date >= ? and date <= ? and account_id = ?", @from, @to, @account.id)
      @transactions = Transaction.transactions_with_totals(@transactions)[0,20]
      @invoice_ids = Invoice.where("date >= ? and date <= ?", @from, @to).map(&:id)
      @invoice_allocations = @invoice_allocations.where("invoice_id in (?)", @invoice_ids)
    end
  end

  def balances
    transactions = Transaction.transactions_with_totals(@account.transactions)
    transactions = transactions[0..(params[:limit].to_i - 1)] if params[:limit]
    balances = transactions.map { |t, b| [(t.date.to_time.to_i * 1000).to_s, b.to_s] } 
    render :json => balances
  end

  def transactions
    # if params[:commit] == "Filter"  
      @transactions = Transaction.transactions_with_totals(@account.transactions)
    # else
      # @transactions = []
    # end
  end

  private

  def redirect_if_closed
    if !current_person.admin? and @account.closed?
      flash[:alert] = "this account is closed and cannot be edited"
      redirect_to [@company, @account]
    end
  end

  def load_account
    account_id = (params[:account_id] || params[:id])
    @account_admin = true
    if current_user.admin?
      @account = Account.find account_id
    elsif @account = Account.where(company_id: current_person.admin_company_ids, id: account_id).first
    elsif @account = current_person.accounts.where(id: account_id).first
    else
      if %w[show balance history transactions].include? action_name
        @account = Account.where(public: true, id: params[:id]).first
        @account_admin = false
      end
    end

    unless @account
      flash[:alert] = 'Account not found or action not permitted'
      redirect_to accounts_path
    end
  end


end
