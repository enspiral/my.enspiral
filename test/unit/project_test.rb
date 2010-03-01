require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  context "worked on relationships" do
    setup do 
      @lachlan = people(:lachlan)
      @sam = people(:sam)
      @project = projects(:enspiral_site)
    end
    
    should "link people to project" do
      assert @lachlan.projects.include?(@project)
      assert @sam.projects.include?(@project)
    end

    should "link project to person" do
      assert @project.people.include?(@lachlan)
      assert @project.people.include?(@sam)
    end

  end
end
