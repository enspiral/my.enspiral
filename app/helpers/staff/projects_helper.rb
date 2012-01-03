module Staff::ProjectsHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction), {:class => css_class}
  end

  def get_persons_name(person_id)
    person = Person.find(person_id)
    person.name
  end

end
