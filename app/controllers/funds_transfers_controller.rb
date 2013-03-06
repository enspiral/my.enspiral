class FundsTransfersController < IntranetController
  before_filter :load_company
  before_filter :source_accounts, only: [:new, :edit, :update, :create]

  def index
    ids = Account.expense.where(company_id: @company.id).collect {|a| a.id}.join(',')
    @funds_transfers = FundsTransfer.where("destination_account_id IN (#{ids}) OR source_account_id IN (#{ids})").order("date", "amount")
  end

  def new
    @funds_transfer = FundsTransfer.new
  end

  def edit
    @funds_transfer = FundsTransfer.find params[:id]
    if administrates_source_account?
      render :edit
    else
      flash[:alert] = 'You are not a souce account administrator'
      redirect_to company_funds_transfer_path(@company)
    end
  end

  def create
    @funds_transfer = current_person.funds_transfers.build(params[:funds_transfer])

    if administrates_source_account?
      if @funds_transfer.save
        flash[:success] = 'Funds Transfer Successful'
        redirect_to [@company, @funds_transfer.source_account]
      else
        render :new
      end
    else
      flash[:alert] = 'You are not a source account administator'
      render :new
    end
  end

  def update
    @funds_transfer = FundsTransfer.find params[:id]
    @funds_transfer.update_attributes(params[:funds_transfer])
    if administrates_source_account?
      if @funds_transfer.save
        flash[:success] = 'Funds Transfer successfuly edited'
        redirect_to company_funds_transfers_path(@company)
      else
        render :edit
      end
    else
      flash[:alert] = 'You are not a source account administator'
      render :index
    end

  end

  private
  def administrates_source_account?
    source_account_id = @funds_transfer.source_account_id
    if @company
      @company.account_ids.include? source_account_id
    else
      current_person.account_ids.include? source_account_id
    end
  end

  def load_company
    @company = Company.find params[:company_id]
  end

  def source_accounts
    if current_person.admin_companies.include? @company
      @source_accounts = @company.accounts.not_closed  
    else
      @source_accounts = current_person.accounts.not_closed.where(company: @company)
    end
  end
end
