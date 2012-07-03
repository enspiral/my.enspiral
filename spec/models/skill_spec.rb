require 'spec_helper'

describe Skill do
  it "should validate presence of description" do
    @skill = Skill.create
    @skill.should have(1).error_on(:name)
  end
end
