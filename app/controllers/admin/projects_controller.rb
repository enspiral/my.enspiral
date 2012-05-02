class Admin::ProjectsController < AdminController

  helper_method :sort_column, :sort_direction

  def index
    @projects = Project.where_status(params[:status]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to admin_projects_path
  end

  private
  
  def sort_column
    Project.column_names.include?(params[:sort]) || params[:sort] == 'customers.name' ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
