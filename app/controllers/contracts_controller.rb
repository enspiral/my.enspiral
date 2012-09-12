class ContractsController < IntranetController
  before_filter :load_contract, except: [:index, :new]

  def index
    @contracts = Contract.active
  end

  def edit
  end

  def new
  end

  def update
  end

  def create
  end

  private 
  def load_contract
    @contract = Contract.find params[:id]
  end
end
