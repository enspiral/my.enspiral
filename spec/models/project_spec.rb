require 'spec_helper'

describe Project do
  before(:each) do
    @project = Project.make!
  end

  it {should belong_to(:customer)} 
  it {should have_many(:people)}

  it "should not save with an invalid status" do
    @project.status = '@#$%^&*'
    @project.save.should be_false
  end

  it 'find by status and return a collection' do
    projects = Project.where_status(@project.status)
    projects.should include(@project)
  end

  it "returns all stati when status 'any' is used" do
    projects = Project.where_status('all')
    projects.should include(@project)
  end
  
  describe "creating a project" do
    it "should create an associated account" do
      @company = Company.make!
      @customer = Customer.make!
      p = Project.create!(:name => 'test', :company => @company, :customer => @customer )
      p.account.should_not be_nil
    end
  end
end
