class MetricsController < IntranetController
  before_filter :check_permissions, :except => :index

  def index
    company
    @metrics = @company.metrics
  end

  def edit
    company
    metric
  end

  def new
    company
    @metric = Metric.new
  end

  def create
    @metric = Metric.new(params[:metric])
    @metric.for_date = @metric.for_date.change(:day => 1)
    @metric.company_id = params[:company_id]
    if @metric.save
      flash[:notice] = "Metric added."
      redirect_to company_metrics_url
    else
      render :new
    end
  end

  def update
    metric
    @metric.update_attributes!(params[:metric])
    redirect_to company_metrics_url
  end

  def destroy
    metric.destroy
    redirect_to company_metrics_url
  end

  private

  def company
    @company = Company.find(params[:company_id])
  end

  def metric
    @metric = Metric.find(params[:id])
  end

  def check_permissions
    unless user_signed_in? and
           current_user.person.admin_companies.where(:id => params[:company_id]).exists?
      redirect_to company_metrics_url(params[:company_id])
    end
  end
end
