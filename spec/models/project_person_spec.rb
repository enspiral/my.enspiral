require 'spec_helper'

describe ProjectPerson do

 before(:each) do
    @projectperson = ProjectPerson.make!
  end

  it {should belong_to(:person)}
  it {should belong_to(:project)}

end
