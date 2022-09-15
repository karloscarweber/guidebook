source 'https://rubygems.org'

gem 'cairn',  '~> 7.1.1'
# we don't have activerecord as a dependency as cairn takes care of that.
gem 'sqlite3'
gem 'rake', '>= 10.0'
gem 'kdl'

group :test do
  gem 'minitest', '~> 5.0'
  gem 'minitest-reporters'
  gem 'rack-test'
  gem 'camping', git: 'https://github.com/karloscarweber/camping', branch: 'camping-3'
  gem 'tilt'
  gem 'puma'
end
