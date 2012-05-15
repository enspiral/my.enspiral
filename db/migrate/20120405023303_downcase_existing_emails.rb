class DowncaseExistingEmails < ActiveRecord::Migration
  def change
    add_column :people, :image_uid, :string
    add_column :projects, :image_uid, :string
    add_column :people, :slug, :string
    add_index :people, :slug, :unique => true
    Person.all.each do |p|
      p.update_attribute(:email, p.email.downcase)
      p.email = p.email.downcase
    end

    User.all.each do |u|
      u.update_attribute(:email, u.email.downcase)
    end
  end
end
