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