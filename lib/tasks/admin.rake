begin

  namespace :admin do
    desc "Check all person emails for gravatars and set person.has_gravatar accordingly"
    task :check_gravatars => :environment do
      @people = Person.all
      @people_with = Person.all(:conditions => ["has_gravatar = ?", true])
      @people_without = Person.all(:conditions => ["has_gravatar = ?", false])
      puts  "Before :: With: #{@people_with.count}  Without: #{@people_without.count}"
      puts "checking #{@people.count} people."
      for person in @people
        puts "checking: #{person.email}"
        unless person.has_gravatar?
         if person.update_gravatar_status(person.email)
           puts "changed status"
         end
        end
      end
      @people_with = Person.all(:conditions => ["has_gravatar = ?", true])
      @people_without = Person.all(:conditions => ["has_gravatar = ?", false])
      puts  "After :: With: #{@people_with.count}  Without: #{@people_without.count}"
    end
  end

end