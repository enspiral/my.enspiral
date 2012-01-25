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
    it "should send emails to all users with default hours available set" do
      person = Person.make! :default_hours_available => 40

      @rake['enspiral:mail_users_capacity_info'].invoke()

      last_email.to.should include(person.email)
      last_email.from.should include('gnome@enspiral.com')
      last_email.body.encoded.should include("Hello #{person.name}")
      last_email.subject.should eq('Your Enspiral Capacity.')

    end
  end
end
