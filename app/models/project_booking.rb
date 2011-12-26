class ProjectBooking < ActiveRecord::Base
  belongs_to :person
  belongs_to :project

  validates :time, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than => 168}
  validates :week, :presence => true

  validates_presence_of :person
  validates_presence_of :project

  def week=(date)
    # If the date is a string, transform it into a date
    if !date.nil? and date.is_a?(String)
      date = Date.strptime(date)
    end
    if date.is_a?(Date)
      # Change the date to the beginning of the week
      write_attribute(:week, date.beginning_of_week)
    else
      # Try write the invalid object to throw the validates error
      write_attribute(:week, date)
    end
  end

  def self.get_persons_projects_bookings(person, weeks)
    # If there is no weeks given as a param, assume the current week onwards
    weeks = self.sanatize_weeks(weeks)
    # For each project we want to get the persons bookings and give back the week and hours booked in a hash
    projects = Hash.new
    for project in person.projects
      bookings = Hash.new
      for week in weeks
        # For each week in each project find the corresponding record, otherwise set to zero.
        booking = self.find_by_person_id_and_project_id_and_week(person.id, project.id, week)
        bookings[week] = booking ? booking.time : 0
      end
      projects[project.id] = bookings
    end
    projects
  end

  def self.get_persons_project_bookings(person, project_id, weeks)
    # If there is no weeks given as a param, assume the current week onwards
    weeks = self.sanatize_weeks(weeks)
    # For a specific project we want the persons bookings and give back a hash of weeks and hours
    
    bookings = Hash.new
    for week in weeks
      # For each week in each project find the corresponding record, otherwise set to zero.
      booking = self.find_by_person_id_and_project_id_and_week(person.id, project_id, week)
      bookings[week] = booking ? booking.time : 0
    end
    
    bookings
  end

  def self.get_persons_total_booked_hours(person, weeks)
    weeks = self.sanatize_weeks(weeks)
    bookings = Hash.new
    for week in weeks
      # For each week in each project find the corresponding record, otherwise set to zero.
      bookings[week] = self.where('person_id = ? and week = ?', person.id, week).sum(:time)
      #bookings[week.beginning_of_week] = booking ? booking.time : 0
    end
    bookings
  end

  def self.sanatize_weeks(weeks)
    formatted_weeks = Array.new

    if !weeks
      for i in (0..4)
        formatted_weeks.push((Date.today + i.weeks).beginning_of_week)
      end
    else
      # Assume weeks were passed in as parameters in a get, therefore will be strings and need converting
      for week in weeks
        if week.is_a?(String)
          week = Date.parse(week)
          formatted_weeks.push(week.beginning_of_week)
        elsif week.is_a?(Date)
          formatted_weeks.push(week == week.beginning_of_week ? week : week.beginning_of_week)
        end
      end
    end
    return formatted_weeks
  end

end
