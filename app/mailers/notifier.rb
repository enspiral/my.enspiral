class Notifier < ActionMailer::Base

  helper ProjectBookingsHelper

  default :from => "no-reply@enspiral.com"
  
  def notify_user_of notice, email
    @notice = notice
    mail :to => email, :from => notice.person.email, :subject => "Enspiral notice: #{notice.summary}"
  end
  
  def contact options = {}
    @options = options
    mail :to => 'contact@enspiral.com', :from => @options[:email], :subject => 'Website Enquiry'
  end

  def capacity_notification(person)
    attachments.inline['time-valid.jpg'] = File.read("#{Rails.root.join('app', 'assets', 'images', 'time-valid.jpg')}")
    attachments.inline['time-invalid.jpg'] = File.read("#{Rails.root.join('app', 'assets', 'images', 'time-invalid.jpg')}")
    attachments.inline['time-pending.jpg'] = File.read("#{Rails.root.join('app', 'assets', 'images', 'time-pending.jpg')}")

    @person = person

    @dates = Array.new
    for i in (1..5)
      @dates.push(Date.today.beginning_of_week + i.weeks)
    end

    @project_bookings = ProjectBooking.get_persons_projects_bookings(@person, @dates)
    @default_time_available = @person.default_hours_available
    @project_bookings_totals = ProjectBooking.get_persons_total_booked_hours_by_week(@person, @dates)
    @formatted_dates = ProjectBooking.get_formatted_dates(@dates)

    mail :to => @person.email, :from => 'gnome@enspiral.com', :subject => 'Your Enspiral Capacity.'
  end
  
end
