module ProjectsHelper
  def add_project_person_link
    link_to_function  "Add a Person" do |page|
      page.insert_html :bottom, :project_person, :partial => 'project_person', :object => ProjectPerson.new
    end
  end
end
