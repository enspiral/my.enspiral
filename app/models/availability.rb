class Availability < ActiveRecord::Base
  belongs_to :person
  belongs_to :project

  ROLES = ['project','availability','unavailability']

  validates :time, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than => 168}
  validates :week, :presence => true

  validates_presence_of :role
  validates_inclusion_of :role, :in => ROLES

  scope :get_offset_batch, lambda { |offset| where(["week >= ? and week <= ?", Date.today.beginning_of_week + (offset.weeks),  Date.today.beginning_of_week + (4 + offset).weeks]) }
  
  scope :by_project, lambda { |id| where("project_id = ? and role = 'project'", id) } 
  
  scope :filter_projects, where(:role => ROLES[0])
  scope :filter_availabilities, where(:role => ROLES[1])
  scope :filter_unavailabilities, where(:role => ROLES[2])


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

  def self.total_hours
    group(:week).sum(:time)
  end
end
