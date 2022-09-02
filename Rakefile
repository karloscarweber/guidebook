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
    t.test_files = FileList['test/guidebook_*.rb']
  end
end

# StandaloneMigrations Loads the tasks into the rake file, but we need to do this differently because we're not using a db/config.yml anymore. We're using a config.kdl. Maybe generate a database config yml file for the Rails thing?
# StandaloneMigrations::Tasks.load_tasks
