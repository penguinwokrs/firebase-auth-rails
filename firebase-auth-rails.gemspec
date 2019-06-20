$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "firebase/auth/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "firebase-auth-rails"
  s.version     = Firebase::Auth::Rails::VERSION
  s.authors     = ["penguinwokrs"]
  s.email       = ["dev.and.penguin@gmail.com"]
  s.homepage    = "https://github.com/penguinwokrs/firebase-auth-rails"
  s.summary     = "Summary of Firebase::Auth::Rails."
  s.description = "Description of Firebase::Auth::Rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  # s.add_development_dependency "rubocop", "~> 0.57"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "redis"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "minitest-stub_any_instance"
  s.add_development_dependency "minitest-retry"
  s.add_dependency "rails"
  s.add_dependency "firebase_id_token", ">= 2.3.0", "~> 2.3"
  s.add_dependency "jwt", ">= 2.1.0", "~> 2.1"
end
