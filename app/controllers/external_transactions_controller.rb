class ExternalTransactionsController < IntranetController

  def index
    account = ExternalAccount.find(params[:external_account_id])
    @transactions = account.external_transactions.unreconciled
  end

  def reconcile
    @external_transaction = ExternalTransaction.find(params[:id])
    @company = @external_transaction.external_account.company
    @funds_transfer = FundsTransfer.new(amount:      @external_transaction.amount,
                                        description: @external_transaction.description,
                                        author:      current_person)
  end

  def create_reconcilation
    @external_transaction = ExternalTransaction.find(params[:id])
    @company = @external_transaction.external_account.company
    @funds_transfer = FundsTransfer.new(params[:funds_transfer])
    @funds_transfer.author = current_person

    if @funds_transfer.valid?
      FundsTransfer.transaction do
        begin
          @funds_transfer.save!
          @external_transaction.funds_transfer = @funds_transfer
          @external_transaction.save!
          flash[:success] = 'Reconciliation successful'
          redirect_to external_account_external_transactions_path(@external_transaction.external_account)
        rescue ActiveRecord::Rollback
          flash[:alert] = 'Could not reconcile expenditure'
          render :reconcile
        end
      end
    else
      flash[:alert] = 'Funds transfer invalid' + @funds_transfer.errors.inspect
      render :reconcile
    end
  end
end
