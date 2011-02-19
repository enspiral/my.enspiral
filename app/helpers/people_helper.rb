module PeopleHelper
  # You have or Person's Name has
  def you_or_name_has person
    admin_user? ? "#{@person.name} has" : "You have"
  end
end
