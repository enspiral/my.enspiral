require 'spec_helper'

describe ProjectMembership do

 before(:each) do
    @projectmembership = ProjectMembership.make!
  end

  it {should belong_to(:person)}
  it {should belong_to(:project)}

end
