module ProjectBookingsHelper
  def get_project_name(project_id)
    project = Project.find(project_id)
    project.name
  end
end
