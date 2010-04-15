def all_staff
  @all_staff ||= {}
end

def staff_with_key key
  raise "No staff member with that name" unless all_staff[key]
  all_staff[key] 
end

Given /^a staff member named (\w*)$/ do |first_name|
  all_staff[first_name] = Person.make(:first_name => first_name) 
end

Given /^a staff member named (\w*) (\w*)$/ do |first_name, last_name|
  all_staff[first_name] = Person.make(
    :first_name => first_name,
    :last_name => last_name
  ) 
end

Given /^I receive (\d*)% of everything I invoice$/ do |percent_keep|
  base_commission = 1 - (percent_keep.to_i / 100 )
  @staff.update_attribute(:base_commission, base_commission)
end


