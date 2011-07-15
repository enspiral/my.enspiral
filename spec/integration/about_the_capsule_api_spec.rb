require 'spec_helper'
require "rest_client"

class Capsule
  def initialize(base_url, api_key)
    @base_url = base_url
    @api_key = api_key
  end
  
  def all_open_opportunities
    result = get map("opportunity")

    require 'json'
    
    json = JSON.parse(result.body) 
    
    json["opportunities"]["opportunity"].select do |opportunity|
      opportunity["milestone"] =~ /^(New|Bid)$/
    end
  end
  
  private 
  
  def map(relative_url); "#{@base_url}/#{relative_url}"; end
  
  def get(url)
    require 'rest_client'
    headers = { "Authorization" => new_auth_header(@api_key)}
    headers["Content-Type"] = headers["Accept"] = "application/json"
    RestClient.get url, headers
  end
  
  def new_auth_header(api_key)
    any_password_it_does_not_matter = "x"
    base_64_credentials = Base64.encode64 "#{api_key}:#{any_password_it_does_not_matter}"
    
    "Basic #{base_64_credentials}"
  end
end

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
  
  it "provides a sales pipeline showing all the currently open opportunities, i.e., ones that have milestone Bid or New" do
    all = Capsule.new(@base_url, @api_key).all_open_opportunities
    
    all.size.should > 0
    
    all.each do |opportunity|
      opportunity["milestone"].should =~ /(New|Bid)/
    end
  end
  
  it "sorts the sales pipeline buy close date ascending"
  it "provides a pipeline forecast (it's on the top left here https://enspiral.capsulecrm.com/pipeline/)"
  it "can search for people"
  
  private
  
  def new_auth_header(api_key)
    any_password_it_does_not_matter = "x"
    base_64_credentials = Base64.encode64 "#{api_key}:#{any_password_it_does_not_matter}"
    
    "Basic #{base_64_credentials}"
  end
end