class DowncaseExistingEmails < ActiveRecord::Migration
  def change
    Person.all.each do |p|
      p.update_attribute(:email, p.email.downcase)
      p.email = p.email.downcase
    end

    User.all.each do |u|
      u.update_attribute(:email, u.email.downcase)
    end
  end
end
