class FundsTransfersController < IntranetController
  before_filter :load_company
  before_filter :load_funds_transfer, only: [:edit, :update, :undo]
  before_filter :source_accounts, only: [:new, :edit, :update, :create]

  def index
    ids = Account.expense.where(company_id: @company.id).collect {|a| a.id}.join(',')
    @funds_transfers = FundsTransfer.where("destination_account_id IN (#{ids}) OR source_account_id IN (#{ids})").order("date", "amount")
  end

  def new
    @funds_transfer = FundsTransfer.new
  end

  def create
    @funds_transfer = current_person.funds_transfers.build(params[:funds_transfer])
    if can_administer_account?
      if @funds_transfer.save
        flash[:success] = 'Funds Transfer Successful'
        redirect_to [@company, @funds_transfer.source_account]
      else
        render :new
      end
    else
      flash[:alert] = "Sorry, you don't have enough privileges to remove money from that account (you need to either own the account or be an administrator)"
      render :new
    end
  end

  def undo
    message = "ok"
    status = 200

    if !current_person.admin? && !@company.admins.include?(current_person)
      # return 403 (Forbidden) if not admin of system or account
      message = "Cannot undo that transaction because you are not an administrator of #{@company.name} or of my.enspiral"
      status = 403
    elsif @funds_transfer.author != current_person
      # return 403 (Forbidden) if transaction not done by you
      message = "Cannot undo that transaction because it was not performed by you"
      status = 403
    elsif @funds_transfer.created_at + 10.minutes < Time.now.utc
      # return 423 (Locked) if after 10 minutes
      message = "Cannot undo that transaction because more than 10 minutes have elapsed"
      status = 423
    elsif @funds_transfer.destination_account.balance - @funds_transfer.amount < @funds_transfer.destination_account.min_balance
      # return 409 (Conflict) if it would overdraw the account
      message = "Cannot undo that transaction because it would overdraw #{@funds_transfer.destination_account.name}!"
      status = 409
    end

    @funds_transfer.destroy if status == 200

    respond_to do |format|
      format.json { render json: message, status: status }
    end
  end

  ###########

  def edit
    if can_administer_account?
      render :edit
    else
      flash[:alert] = "Sorry, you don't have enough privileges to remove money from that account (you need to either own the account or be an administrator)"
      redirect_to company_funds_transfer_path(@company)
    end
  end

  def update
    @funds_transfer.update_attributes(params[:funds_transfer])
    if can_administer_account?
      if @funds_transfer.save
        flash[:success] = 'Funds Transfer successfuly edited'
        redirect_to company_funds_transfers_path(@company)
      else
        render :edit
      end
    else
      flash[:alert] = "Sorry, you don't have enough privileges to remove money from that account (you need to either own the account or be an administrator)"
      render :index
    end

  end

  private
  def can_administer_account?(account = @funds_transfer.source_account)
    if current_person.admin_companies.include? @company
      @company.account_ids.include? account.id
    else
      current_person.account_ids.include? account.id
    end
  end

  def load_company
    @company = Company.find params[:company_id]
  end

  def load_funds_transfer
    @funds_transfer = FundsTransfer.find params[:id]
  end

  def source_accounts
    if current_person.admin_companies.include? @company
      @source_accounts = @company.accounts.not_closed  
    else
      @source_accounts = current_person.accounts.not_closed.where(company_id: @company.id)
    end
  end
end
