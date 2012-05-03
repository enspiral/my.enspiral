class FundsTransfersController < IntranetController
  def new
    @funds_transfer = FundsTransfer.new
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
        flash[:notice] = 'Funds Transfer Successful'
        redirect_to [@company, @funds_transfer.source_account]
      else
        render :new
      end
    else
      flash[:alert] = 'You are not a source account administator'
      render :new
    end
  end
end
