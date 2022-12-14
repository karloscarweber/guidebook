Gem::Specification.new do |s|
  s.name        = "guidebook"
  s.version     = "0.0.8"
  s.summary     = "Active Record in your Camping app"
  s.description = "Want models? Want migrations? GuideBook is a Camping Gear to give you Database persistence and models through ActiveRecord."
  s.authors     = ["Karl Oscar Weber"]
  s.email       = "me@kow.fm"
  s.files       = ["lib/guidebook.rb", "lib"]

  s.files = %w(README.md) +
    Dir.glob("{bin,lib}/**/*")

  s.executables = ['guidebook']

  s.bindir      = "bin"
  s.require_path = "lib"
  s.add_runtime_dependency 'activerecord', '~> 7.0', '>= 7.0.3.1'
  s.add_runtime_dependency 'sqlite3', '~> 1.4', '>= 1.4.4'
  s.add_runtime_dependency 'cairn', '>= 7.1.0'
  s.add_runtime_dependency 'kdl', '>= 1.0.3'
  s.homepage    = "https://rubygems.org/gems/guidebook"
  s.license     = "MIT"

end

