module Staff::AvailabilitiesHelper

  def find_or_create_availabilities_batch(offset, person, role, project = nil)
    project_id = project ? project.id : nil
    availabilities = Array.new
    for i in (offset..(4 + offset)) do
      availability = Availability.find_or_create_by_person_id_and_week_and_role_and_project_id(:person_id => person.id, :week => Date.today + i.weeks, :role => role, :project_id => project_id)
      if !availability.time
        availability.time = person.default_hours_available || 0
      end 
      availability.save!
      availabilities.push(availability)
    end
    availabilities
  end

end
