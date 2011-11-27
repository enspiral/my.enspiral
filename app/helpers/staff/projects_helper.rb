module Staff::ProjectsHelper

  def fields_for_project_people(project_person, &block)
    prefix = project_person.new_record? ? 'new' : 'existing'
    fields_for("project[#{prefix}_project_people_attributes][]", project_person, &block)
  end
  
  def add_project_person_link
    fields = render :partial => 'project_person', :object => ProjectPerson.new
    link_to_function("project_person", h("add_fields(this, 'project_person', '#{escape_javascript(fields)}')"))
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
end
