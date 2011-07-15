require "spec_helper"

describe Capsule do
  before :all do 
    @api_key    = "6ec1e14f52e4e5e7394dcf24fbf01ae9"
    @base_url   = "https://enspiral.capsulecrm.com/api" 
  end
  
  it "all the currently open opportunities have milestone either 'Bid' or 'New'" do
    all = Capsule.new(@base_url, @api_key).all_open_opportunities
    
    all.size.should(be > 0, "Expected at least one opportunity to be returned")
    
    all.each do |opportunity|
      opportunity["milestone"].should =~ /(New|Bid)/
    end
  end
  
  it "sorts the sales pipeline buy id"
  it "provides a pipeline forecast (it's on the top left here https://enspiral.capsulecrm.com/pipeline/)"
  it "can search for people"
end