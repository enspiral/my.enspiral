class Notifier < ActionMailer::Base
  default :from => "no-reply@enspiral.com"
  
  def notify_user_of notice, email
    @notice = notice
    mail :to => email, :from => notice.person.email, :subject => "Enspiral notice: #{notice.summary}"
  end
  
end
