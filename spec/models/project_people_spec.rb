require 'spec_helper'

describe ProjectPeople do

 before(:each) do
    @projectperson = ProjectPeople.make!
  end

  it {should belong_to(:person)}
  it {should belong_to(:project)}

end
