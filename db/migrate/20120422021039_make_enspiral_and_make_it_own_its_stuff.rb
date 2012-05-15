class MakeEnspiralAndMakeItOwnItsStuff < ActiveRecord::Migration
  def up
    add_column :projects, :slug, :string
    add_index :projects, :slug, :unique => true
    add_column :companies, :slug, :string
    add_index :companies, :slug, :unique => true
    add_column :companies, :image_uid, :string
    add_column :accounts, :closed, :boolean, :default => false, :null => false
    add_column :people, :rate, :decimal
    @enspiral = Company.create!(name:'Enspiral', default_commission: 0.20)

    @enspiral.customers = Customer.all
    @enspiral.invoices = Invoice.all
    @enspiral.people = Person.all
    @enspiral.accounts = Account.all
    @enspiral.projects = Project.all
    @enspiral.save

    admin_emails = %w[joshua@enspiral.com rob@enspiral.com allansideas@gmail.com alanna@enspiral.com alex.gibson@enspiral.com josh.forde@enspiral.com]

    admin_emails.each do |email|
      person = Person.find_by_email(email)
      if person
        cm = CompanyMembership.find_by_person_id(person.id)
        cm.update_attribute(:admin, true)
      end
    end
    r = User.find_by_email 'rob@enspiral.com'
    r.password = 'password'
    r.save
  end
  def down
    remove_column :companies, :image_uid
    remove_column :projects, :slug
    remove_index :projects, :slug
    remove_column :companies, :slug
    remove_index :companies, :slug
    remove_column :accounts, :closed
    remove_column :people, :rate
  end
end
