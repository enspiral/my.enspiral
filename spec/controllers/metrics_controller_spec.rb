require 'spec_helper'

describe MetricsController do
  describe "#index" do
    it "should render successfully" do
      pending "at the moment this only works inside of companies"
      get :index, :company_id => Enspiral::CompanyNet::Company.make!.id
      response.should be_successful
    end
  end

  describe "#update" do
    it "should not let you update someone else's metrics"
  end

  describe "#destroy" do
    it "should not let you update someone else's metrics"
  end

end
