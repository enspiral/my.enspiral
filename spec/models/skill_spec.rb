require 'spec_helper'

describe Skill do
  pending "add some examples to (or delete) #{__FILE__}"
  
  it "should validate presence of description" do
    @skill = Skill.create
    @skill.should have(1).error_on(:description) 
  end
end
