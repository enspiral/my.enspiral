class FundsTransfersController < Staff::Base
  def new
    @funds_transfer = FundsTransfer.new
  end

  def create
    @funds_transfer = current_person.funds_transfers.build(params[:funds_transfer])
    if @funds_transfer.save
      flash[:notice] = 'Funds Transfer Successful'
      redirect_to account_path(@funds_transfer.source_account)
    else
      render :new
    end
  end
end
