class PeopleSkill < ActiveRecord::Base
  belongs_to :person
  belongs_to :skill
end
