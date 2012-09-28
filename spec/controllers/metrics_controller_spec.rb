require 'spec_helper'

describe MetricsController do
  describe "#index" do
    it "should render successfully" do
      pending "at the moment this only works inside of companies"
      get :index, :company_id => Company.make!.id
      response.should be_successful
    end
  end

end
