require 'spec_helper'
require "rest_client"

describe "Using the capsule API to fetch a pipeline summary" do
  before :all do 
    @api_key    = "6ec1e14f52e4e5e7394dcf24fbf01ae9"
    @password   = "x"
    @base_url   = "https://enspiral.capsulecrm.com/api"
  end
  
  it "authorization works" do
    base_64_credentials = Base64.encode64 "#{@api_key}:#{@password}"
    
    headers = { "Authorization" => "Basic #{base_64_credentials}"}
    
    url = "#{@base_url}/party"
    
    result = RestClient.get url, headers
    
    result.code.should === 200
  end
  
  it "you can ask for json" do
    headers = { "Authorization" => new_auth_header(@api_key)}
    headers["Content-Type"] = headers["Accept"] = "application/json"
    
    url = "#{@base_url}/party"
    
    result = RestClient.get url, headers

    require 'json'

    lambda {JSON.parse result.body}.should_not raise_error
  end
  
  private
  
  def new_auth_header(api_key)
    any_password_it_does_not_matter = "x"
    base_64_credentials = Base64.encode64 "#{api_key}:#{any_password_it_does_not_matter}"
    
    "Basic #{base_64_credentials}"
  end
end