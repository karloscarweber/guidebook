require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'tempfile'
require 'open3'
require 'cairn'

task :default => :test
task :test => 'test:all'

namespace 'test' do
  Rake::TestTask.new('all') do |t|
    t.libs << 'test'
    t.test_files = FileList['test/guidebook_*.rb']
  end
end

StandaloneMigrations::Tasks.load_tasks
