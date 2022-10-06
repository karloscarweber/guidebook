require 'rake'
require 'rake/task'
require 'rake/clean'
require 'rake/testtask'
require 'tempfile'
require 'open3'
require 'cairn'
require 'guidebook'
require 'guidebook/version'

task :default => :test
task :test => 'test:all'
task :queries => 'test:queries'
task :kdl => 'test:kdl'
task :commands => 'test:cmd'
task :pack => 'test:packed'
task :config => 'test:hasconfig'
# task :build => 'build:build'

namespace 'test' do
  Rake::TestTask.new('all') do |t|
    t.libs << 'test'
    t.libs.push 'lib'
    t.test_files = FileList['test/guidebook_*.rb', 'test/spec_*.rb']
  end
  Rake::TestTask.new('queries') do |t|
    t.libs << 'test'
    t.libs.push 'lib'
    t.test_files = FileList['test/guidebook_doesqueries.rb']
  end
  Rake::TestTask.new('kdl') do |t|
    t.libs << 'test'
    t.libs.push 'lib'
    t.test_files = FileList['test/guidebook_parses-kdl.rb']
  end
  Rake::TestTask.new('cmd') do |t|
    t.libs << 'test'
    t.libs.push 'lib'
    t.test_files = FileList['test/spec_*.rb']
  end
  Rake::TestTask.new('packed') do |t|
    t.libs << 'test'
    t.libs.push 'lib'
    t.test_files = FileList['test/guidebook_packedup.rb']
  end
  Rake::TestTask.new('hasconfig') do |t|
    t.libs << 'test'
    t.libs.push 'lib'
    t.test_files = FileList['test/guidebook_hasconfig.rb']
  end
end

desc "Builds the gem"
task :build  do
  system "gem build guidebook.gemspec"
end

desc "Builds AND installs the gem"
task :install  do
  system "gem build guidebook.gemspec; gem install guidebook-" + Camping::GuideBook::VERSION + ".gem"
end

desc "Publish the gem to rubygems.org"
task :publish do
  system 'gem push guidebook-' + Camping::GuideBook::VERSION + ".gem"
end

desc "Clean the folder of all our dust"
task :clean do
  system "rm *.gem"
end
