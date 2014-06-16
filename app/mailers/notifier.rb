class Notifier < ActionMailer::Base

  helper YourCapacityHelper

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
    @start_on = Date.today.at_beginning_of_week
    @finish_on = @start_on + 8.weeks
    @person = person
    mail :to => @person.email, :from => 'no-reply@enspiral.com', :subject => '[enspiral] Your Project Bookings'
  end

  def send_welcome
    # @notice = notice
    mail :to => "reaksmey@enspiral.com", :from => "gnome@enspiral.com", :subject => "you have registered"
  end
  
end
