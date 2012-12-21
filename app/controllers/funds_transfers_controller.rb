class FundsTransfersController < IntranetController
  def new
    @funds_transfer = Enspiral::MoneyTree::FundsTransfer.new
  end

  def create
    @funds_transfer = current_person.funds_transfers.build(params[:funds_transfer])
    source_account_id = params[:funds_transfer][:source_account_id].to_i

    if is_owner?
      if @funds_transfer.save
        flash[:success] = 'Funds Transfer Successful'
        if @company
          redirect_to enspiral_company_net_company_enspiral_money_tree_account_path(@company, @funds_transfer.source_account)
        else
          redirect_to enspiral_money_tree_account_path(@funds_transfer.source_account)
        end
      else
        render :new
      end
    else
      flash[:alert] = 'You are not a source account administator'
      render :new
    end
  end

  private

    def source_account
      @funds_transfer.source_account
    end

    def is_owner?
      if @company
        source_account.owned_by_company?(@company)        
      else
        source_account.owned_by_person?(current_person)
      end
    end
end
