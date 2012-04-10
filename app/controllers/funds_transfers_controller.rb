class FundsTransfersController < Staff::Base
  def new
    @funds_transfer = FundsTransfer.new
  end

  def create
    @funds_transfer = current_person.funds_transfers.build(
      params[:funds_transfer])
    if @funds_transfer.save
      flash[:notice] = 'Funds Transfer Successful'
      redirect_to staff_account_path(@funds_transfer.source_account)
    else
      puts @funds_transfer.errors.messages
      render :new
    end
  end
end
