class Notice < ActiveRecord::Base
  
  belongs_to :person
  
  validates_presence_of :person_id, :summary, :text
  
  attr_accessor :notify
  
  after_create :notify_users
  
  protected
  
  def notify_users
    User.where("id != ?", self.person.user_id).each { |user| Notifier.notify_user_of(self, user.email).deliver } if self.notify.to_s == '1'
  end
  
end
