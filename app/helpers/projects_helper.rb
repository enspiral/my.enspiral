module ProjectsHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction), {:class => css_class}
  end

  def get_persons_name(person_id)
    person = Enspiral::CompanyNet::Person.find(person_id)
    person.name
  end

  def is_project_lead(project_id, person_id)
    ProjectMembership.find_by_project_id_and_person_id(project_id, person_id).is_lead || false
  end

end
