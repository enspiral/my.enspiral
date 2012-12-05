$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "enspiral_company_net/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enspiral_company_net"
  s.version     = EnspiralCompanyNet::VERSION
  s.authors     = ["Craig Ambrose"]
  s.email       = ["craig@craigambrose.com"]
  s.homepage    = "http://www.enspiral.com"
  s.summary     = "TODO: Summary of EnspiralCompanyNet."
  s.description = "TODO: Description of EnspiralCompanyNet."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  # s.add_dependency "jquery-rails"

end
