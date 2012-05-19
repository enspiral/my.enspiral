class FundsTransferTemplatesController < IntranetController
  before_filter :load_template, only: [:show, :edit, :update, :destroy, :generate]

  def index
    @funds_transfer_templates = @company.funds_transfer_templates
  end

  def new
    @funds_transfer_template = @company.funds_transfer_templates.new
  end

  def show
  end

  def edit
  end

  def create
    @funds_transfer_template = @company.funds_transfer_templates.build params[:funds_transfer_template]
    if @funds_transfer_template.save
      redirect_to [@company, @funds_transfer_template],
        notice: 'Funds Transfer Template Created'
    else
      render :new
    end
  end

  def update
    if @funds_transfer_template.update_attributes(params[:funds_transfer_template])
      redirect_to [@company, @funds_transfer_template],
        notice: 'Funds Transfer Template Updated'
    else
      render :edit
    end
  end

  def destroy
    @funds_transfer_template.destroy
    redirect_to :index,
      notice: 'FundsTransferTemplate destroyed'
  end

  def generate
    @transfers = @funds_transfer_template.generate_funds_transfers(author: current_person)
  end

  protected
  def load_template
    @funds_transfer_template = @company.funds_transfer_templates.find params[:id]
  end
end
