require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'tempfile'
require 'open3'
require 'cairn'
require 'guidebook'

task :default => :test
task :test => 'test:all'

namespace 'test' do
  Rake::TestTask.new('all') do |t|
    t.libs << 'test'
    t.libs.push 'lib'
    t.test_files = FileList['test/guidebook_*.rb', 'test/spec_*.rb']
  end
end

# This should be loaded in a Rake file but how do I test that?
# StandaloneMigrations::Tasks.load_tasks
