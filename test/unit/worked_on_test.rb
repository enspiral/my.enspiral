require 'test_helper'

class WorkedOnTest < ActiveSupport::TestCase
  context "basic crud" do
    should "load from db" do
      assert !worked_ons(:lachlan_worked_on_enspiral).nil?
    end
  end
end
