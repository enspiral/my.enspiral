class MakeEnspiralAndMakeItOwnItsStuff < ActiveRecord::Migration
  def up
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
end
