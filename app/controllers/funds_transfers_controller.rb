require 'transaction_errors/transaction_errors'

class FundsTransfersController < IntranetController
  include TransactionErrors

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

    begin
      @funds_transfer.try_to_undo(@company, current_person)
    rescue TransactionErrors::InsufficientPrivilegesError => e
      message = e.message
      status = 403
    rescue TransactionErrors::SomeoneElsesTransactionError => e
      message = e.message
      status = 403
    rescue TransactionErrors::TooLateToUndoError => e
      message = e.message
      status = 423
    rescue TransactionErrors::InsufficientFundsError => e
      message = e.message
      status = 409
    end

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
