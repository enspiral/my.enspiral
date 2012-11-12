class FundsTransfersController < IntranetController
  def new
    @funds_transfer = Enspiral::MoneyTree::FundsTransfer.new
  end

  def create
    @funds_transfer = current_person.funds_transfers.build(params[:funds_transfer])
    source_account_id = params[:funds_transfer][:source_account_id].to_i

    owner = if @company
              @company.account_ids.include? source_account_id
            else
              current_person.account_ids.include? source_account_id
            end

    if owner
      if @funds_transfer.save
        flash[:success] = 'Funds Transfer Successful'
        if @company
          redirect_to company_enspiral_money_tree_account_path(@company, @funds_transfer.source_account)
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
end
