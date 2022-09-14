require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'tempfile'
require 'open3'
require 'cairn'
require 'guidebook'

task :default => :test
task :test => 'test:all'
task :queries => 'test:queries'
task :kdl => 'test:kdl'
task :commands => 'test:cmd'
task :pack => 'test:packed'
task :config => 'test:hasconfig'

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

# This should be loaded in a Rake file but how do I test that?
# StandaloneMigrations::Tasks.load_tasks
