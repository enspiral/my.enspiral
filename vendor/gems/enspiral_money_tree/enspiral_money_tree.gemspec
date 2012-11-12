$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "enspiral_money_tree/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enspiral_money_tree"
  s.version     = EnspiralMoneyTree::VERSION
  s.authors     = ["Craig Ambrose", "Joshua Vial"]
  s.email       = ["craig@craigambrose.com", "joshua@enspiral.com"]
  s.homepage    = "http://www.enspiral.com"
  s.summary     = "TODO: Summary of EnspiralMoneyTree."
  s.description = "TODO: Description of EnspiralMoneyTree."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  # s.add_dependency "jquery-rails"

  # s.add_development_dependency "sqlite3"
end
