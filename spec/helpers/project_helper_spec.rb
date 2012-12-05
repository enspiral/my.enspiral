require 'spec_helper'

describe ProjectsHelper do

  it 'returns a bool determining a project lead' do
    project = Enspiral::CompanyNet::Project.make!
    project_lead = Enspiral::CompanyNet::Person.make!
    person = Enspiral::CompanyNet::Person.make!
    ProjectMembership.make! :project => project, :person => project_lead, :is_lead => true
    ProjectMembership.make! :project => project, :person => person

    is_project_lead(project.id, project_lead.id).should eq(true)
    is_project_lead(project.id, person.id).should eq(false)
  end

  it 'gets a persons name given a persons id' do
    person = Enspiral::CompanyNet::Person.make!
    get_persons_name(person.id).should eq(person.name)
  end
end
