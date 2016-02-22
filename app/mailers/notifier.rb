class Notifier < ActionMailer::Base

  helper YourCapacityHelper

  default :from => "no-reply@enspiral.com"

  def current_developer_emails
    ["charlie@enspiral.com"]
  end
  
  def notify_user_of notice, email
    @notice = notice
    mail :to => email, :from => notice.person.email, :subject => "my.enspiral notice: #{notice.summary}"
  end

  def alert_company_admins_of_failing_invoice_import company, total_invoice_count, invoices_with_errors
    @company = company
    @invoices_with_errors = invoices_with_errors
    @total_invoice_count = total_invoice_count

    @company.admins.map(&:email).compact
    mail to: "charlie@enspiral.com", subject: "my.enspiral import script has failed to import #{invoices_with_errors.count} invoices"
  end

  def mail_current_developers error, company
    # airbrake sends out a lot of errors - this is to make sure it gets through!

    @company = company
    @error = error

    current_developer_emails
    mail to: "charlie@enspiral.com", subject: "my.enspiral script has encountered a config error!"
  end
  
  def contact options = {}
    @options = options
    mail :to => 'contact@enspiral.com', :from => @options[:email], :subject => 'Website Enquiry'
  end

  def capacity_notification(person)
    @start_on = Date.today.at_beginning_of_week
    @finish_on = @start_on + 8.weeks
    @person = person
    mail :to => @person.email, :from => 'no-reply@enspiral.com', :subject => "[#{APP_CONFIG[:organization]}] Your Project Bookings"
  end

  def send_welcome person, params
    @person = person
    @password = params[:password]
    mail :to => person.email, :from => "gnome@enspiral.com", :subject => "Welcome #{person.email}"
  end

  def alert_funds_cleared_out person, amount 
    @person = person
    @amount = amount
    mail :to => person.email, :from => "gnome@enspiral.com", :subject => "Funds has been transfer to your account"
  end
  
end
