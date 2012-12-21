require 'spec_helper'

module Enspiral
  module CompanyNet
    describe Project do
      subject { Project.make }

      it {should belong_to(:customer)} 
      it {should have_many(:people)}

      describe "creating" do
        it "should create an associated account" do
          @company = Enspiral::CompanyNet::Company.make!
          @customer = Enspiral::CompanyNet::Customer.make!
          p = Project.create!(:name => 'test', :company => @company, :customer => @customer, :due_date => 2.days.from_now, :amount_quoted => 110 )
          p.account.should_not be_nil
        end

        it "fails with an invalid status" do
          subject.status = '@#$%^&*'
          subject.save.should be_false
        end
      end

      describe ".find_by_status" do
        before :each do
          subject.save!
        end

        it 'returns a project with that status' do
          projects = Project.where_status(subject.status)
          projects.map(&:id).should include(subject.id)
        end

        it "returns all states when status 'any' is used" do
          projects = Project.where_status('all')
          projects.map(&:id).should include(subject.id)
        end
      end
    end
  end
end