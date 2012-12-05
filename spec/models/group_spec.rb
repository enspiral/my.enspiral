require 'spec_helper'

describe Group do
  it "should validate presence of description" do
    @group = Group.create
    @group.should have(1).error_on(:name) 
  end

  it 'should delete associated people_group rows on destroy' do
    @person = Enspiral::CompanyNet::Person.make
    @person.save
    @group = Group.create(name: 'bobsgroup')
    @group.save
    @person.groups << @group
    @person.groups.length.should == 1
    lambda {
      @group.destroy
    }.should change(PeopleGroup, :count).by(-1)
  end
end
