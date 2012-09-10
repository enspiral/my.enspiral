require 'spec_helper'
require 'rake'

describe "rake" do
  before do
    @rake = Rake::Application.new
    Rake.application = @rake
    # previously was trying
    # Rake.application.rake_require "tasks/get_comic"
    load Rails.root + 'lib/tasks/enspiral.rake'
    Rake::Task.define_task(:environment)
  end

  describe "task mail_users_capacity_info" do
    it "should have 'environment' as a prerequisite" do
      @rake['enspiral:mail_users_capacity_info'].prerequisites.should include("environment")
    end
    it "should send emails to all users with default hours available set who are assigned to projects" do
      person = Person.make! :default_hours_available => 40
      project = Project.make!
      project.people << person

      Notifier.should_receive(:capacity_notification).and_return(Notifier)
      Notifier.should_receive(:deliver)

      @rake['enspiral:mail_users_capacity_info'].invoke()
    end
  end
end
