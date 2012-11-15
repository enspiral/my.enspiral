require 'spec_helper'

describe Metric do
  it {should belong_to :company}

  context "for date" do
    it "should be unique" do
      m = Metric.make!
      m2 = Metric.new(company: m.company, for_date: m.for_date)
      m2.should be_invalid
    end
    it "should be scoped to company" do
      m = Metric.make!
      m2 = Metric.new(company: Enspiral::CompanyNet::Company.make, for_date: m.for_date)
      m2.should be_valid
    end
  end
  
end
