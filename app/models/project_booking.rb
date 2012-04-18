class ProjectBooking < ActiveRecord::Base
  belongs_to :project_membership

  validates :time, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than => 168}
  validates :week, :presence => true

  validates_presence_of :project_membership

  validates_uniqueness_of :project_membership_id, :scope => :week

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

  def self.get_projects_project_bookings(project, weeks)
    # If there is no weeks given as a param, assume the current week onwards
    weeks = self.sanatize_weeks(weeks)
    project_bookings = Hash.new

    for project_membership in project.project_memberships
      bookings = Hash.new
      for week in weeks
        # For each week in each project find the corresponding record, otherwise set to zero.
        booking = self.find_by_project_membership_id_and_week(project_membership.id, week)
        bookings[week] = booking ? booking.time : 0
      end
      project_bookings[project_membership.person.id] = bookings
    end
    project_bookings
  end

  def self.get_persons_projects_bookings(person, weeks)
    # If there is no weeks given as a param, assume the current week onwards
    weeks = self.sanatize_weeks(weeks)
    # For each project we want to get the persons bookings and give back the week and hours booked in a hash
    projects = Hash.new

    for project_membership in person.project_memberships
      bookings = Hash.new
      for week in weeks
        # For each week in each project find the corresponding record, otherwise set to zero.
        booking = self.find_by_project_membership_id_and_week(project_membership.id, week)
        bookings[week] = booking ? booking.time : 0
      end
      projects[project_membership.project.id] = bookings
    end
    projects
  end

  def self.get_persons_project_bookings(project_membership, weeks)
    # If there is no weeks given as a param, assume the current week onwards
    weeks = self.sanatize_weeks(weeks)
    # For a specific project we want the persons bookings and give back a hash of weeks and hours
    
    bookings = Hash.new
    for week in weeks
      # For each week in each project find the corresponding record, otherwise set to zero.
      booking = self.find_by_project_membership_id_and_week(project_membership.id, week)
      bookings[week] = booking ? booking.time : 0
    end
    
    bookings
  end

  def self.get_persons_total_booked_hours_by_week(person, weeks)
    weeks = self.sanatize_weeks(weeks)
    bookings = Hash.new
    for week in weeks
      # For each week in each project find the corresponding record, otherwise set to zero.
      bookings[week] = self.joins('LEFT OUTER JOIN project_memberships ON project_memberships.id = project_bookings.project_membership_id')
        .where('project_memberships.person_id = ? and project_bookings.week = ?', person.id, week).sum('project_bookings.time')
    end
    bookings
  end

  def self.get_peoples_total_booked_hours_by_week(weeks)
    people = Person.where("default_hours_available IS NOT NULL")
    people_capacity = Hash.new

    people.each do | person |
      people_capacity[person] = self.get_persons_total_booked_hours_by_week(person, weeks)
    end

    return people_capacity
  end

  def self.get_projects_total_booked_hours_by_week(project, weeks)
    weeks = self.sanatize_weeks(weeks)
    bookings = Hash.new
    for week in weeks
      # For each week in each project find the corresponding record, otherwise set to zero.
      bookings[week] = self.joins('LEFT OUTER JOIN project_memberships ON project_memberships.id = project_bookings.project_membership_id')
        .where('project_memberships.project_id = ? and project_bookings.week = ?', project.id, week).sum('project_bookings.time')
    end
    bookings
  end


  def self.get_projects_total_booked_hours(project)
    self.joins('LEFT OUTER JOIN project_memberships ON project_memberships.id = project_bookings.project_membership_id')
        .where('project_memberships.project_id = ?', project.id).sum('project_bookings.time')
  end

  def self.sanatize_weeks(weeks)
    formatted_weeks = Array.new

    if !weeks
      for i in (0..4)
        formatted_weeks.push((Date.today + i.weeks).beginning_of_week)
      end
    else
      # Assume weeks were passed in as parameters in a get, therefore they will be strings and will need converting
      for week in weeks
        if week.is_a?(String)
          week = Date.parse(week)
        end
        formatted_weeks.push(week.beginning_of_week)
      end
    end
    return formatted_weeks
  end

  def self.get_formatted_dates(weeks)
    formatted_weeks = Array.new

    if !weeks
      for i in (0..4)
        formatted_weeks.push(self.format_date(Date.today + i.weeks))
      end
    else
      # Assume weeks were passed in as parameters in a get, therefore will be strings and need converting
      for week in weeks
        if week.is_a?(String)
          week = Date.parse(week)
          formatted_weeks.push(self.format_date(week))
        elsif week.is_a?(Date)
          formatted_weeks.push(self.format_date(week))
        end
      end
    end
    return formatted_weeks

  end

  def self.format_date(date)
    if date.beginning_of_week == Date.today.beginning_of_week
      return 'This Week'
    elsif date.beginning_of_week == (Date.today + 1.week).beginning_of_week
      return 'Next Week'
    elsif date.beginning_of_week == (Date.today - 1.week).beginning_of_week
      return 'Last Week'
    else
      return date.beginning_of_week.strftime('%b %-d')
    end
  end

  def self.next_weeks(weeks)
    next_weeks =  self.sanatize_weeks(weeks)
    next_weeks.map { |week| week + 1.week}
  end

  def self.previous_weeks(weeks)
    previous_weeks =  self.sanatize_weeks(weeks)
    previous_weeks.map { |week| week - 1.week}
  end
end
