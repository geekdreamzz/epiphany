$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "epiphany/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "epiphany"
  spec.version     = Epiphany::VERSION
  spec.authors     = ["geekdreamzz"]
  spec.email       = ["geekdreamzz@gmail.com"]
  spec.homepage    = "http://www.geeklevel1000.com"
  spec.summary     = "Build Custom Voice Assistant Services"
  spec.description = "Open Source Ruby on Rails Engine to build custom voice assistants"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.3"
  spec.add_dependency "pry-byebug"
  spec.add_development_dependency "sqlite3"
end
