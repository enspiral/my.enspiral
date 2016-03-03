require 'transaction_errors/transaction_errors'

class FundsTransfersController < IntranetController
  include TransactionErrors
  include ApplicationHelper

  before_filter :load_company
  before_filter :load_funds_transfer, only: [:edit, :update]
  before_filter :source_accounts, only: [:new, :edit, :update, :create]

  def index
    @start_date = params[:start_date]
    @end_date = params[:end_date]

    if @start_date && @end_date
      transfer_scope = FundsTransfer.performed_between(@start_date, @end_date)
    elsif @start_date
      transfer_scope = FundsTransfer.performed_after(@start_date)
    elsif @end_date
      transfer_scope = FundsTransfer.performed_before(@end_date)
    else
      @end_date = today_in_zone(@company)
      @start_date = @end_date - @end_date.wday + 1
      transfer_scope = FundsTransfer.performed_between(@start_date, @end_date)
    end

    ids = Account.where(company_id: @company.id).map(&:id).join(',')
    @funds_transfers = transfer_scope.where("destination_account_id IN (#{ids})").order("date DESC").page params[:page]
  end

  def external
    ids = Account.expense.where(company_id: @company.id).collect {|a| a.id}.join(',')
    @funds_transfers = FundsTransfer.where("destination_account_id IN (#{ids}) OR source_account_id IN (#{ids})").order("date", "amount").page params[:page]
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

    account_id = params[:account_id]
    begin
      @account = Account.find(account_id)
    rescue
    end

    begin
      @funds_transfer = FundsTransfer.find(params[:id])
      @funds_transfer.try_to_undo(@company, current_person)
      flash[:notice] = "Transfer removed successfully."
    rescue TransactionErrors::InsufficientPrivilegesError => e
      flash[:error] = e.message
    rescue TransactionErrors::SomeoneElsesTransactionError => e
      flash[:error] = e.message
    rescue TransactionErrors::TooLateToUndoError => e
      # it's been 10 minutes! reverse instead!
      @funds_transfer.create_reverse_transfer(current_person)
    rescue TransactionErrors::InsufficientFundsError => e
      flash[:error] = e.message
    rescue ActiveRecord::RecordNotFound => e
      flash[:error] = "That transfer does not exist. It may have already been removed."
    rescue => e
      flash[:error] = "Another error occurred: #{e.message}"
    end

    if @account
      redirect_to @account
    else
      redirect_to accounts_path
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
        flash[:success] = 'Funds Transfer successfully edited'
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
