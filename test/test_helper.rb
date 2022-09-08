$:.unshift File.dirname(__FILE__) + '/../lib'
$:.unshift File.dirname(__FILE__) + '/../' # I think this will let us see db folder

# test_helper.rb
begin
  require 'rubygems'
rescue LoadError
end

require 'camping'
require 'minitest/autorun'
require 'minitest'
require 'minitest/spec'
require 'rack/test'
require "minitest/reporters"
require_relative '../lib/guidebook.rb'
require 'fileutils'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

class TestCase < MiniTest::Test
  include Rack::Test::Methods

  def self.inherited(mod)
    mod.app = Object.const_get(mod.to_s[/\w+/])
    super
  end

  class << self
    attr_accessor :app
  end

  def body() last_response.body end
  def app()  self.class.app     end

  def assert_reverse
    begin
      yield
    rescue Exception
    else
      assert false, "Block didn't fail"
    end
  end

  def assert_body(str)
    case str
    when Regexp
      assert_match(str, last_response.body.strip)
    else
      assert_equal(str.to_s, last_response.body.strip)
    end
  end

  def assert_status(code)
    assert_equal(code, last_response.status)
  end

  def test_silly; end

end

# def stand_up_db
#   ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
# end
# Page = Doesqueries::Models::Page
# def nuke_db
#   Page.new(title: "Hiking", content: "Fishing").save
#   Page.all.each(&:delete)
# end
# # Stand up a whole camping app here:


module ComandLineCommands
  # Useful functinos from standalone-migrations

  # write file
  def write(file, content)
    raise "cannot write nil" unless file
    file = tmp_file(file)
    folder = File.dirname(file)
    `mkdir -p #{folder}` unless File.exist?(folder)
    File.open(file, 'w') { |f| f.write content }
  end

  # read file
  def read(file)
    File.read(tmp_file(file))
  end

  # tmp_file, gets the temp file
  def tmp_file(file)
    "test/tmp/#{file}"
  end

  # runs a command on the command line, in the test directory
  def run_cmd(cmd)
    result = `cd test/tmp && #{cmd} 2>&1`
    raise result unless $?.success?
    result
  end

  def schema
    ENV['SCHEMA'] || "db/schema.rb"
  end

  # writes a rakefile
  def write_rakefile(config=nil)
      write 'Rakefile', <<-TXT
$LOAD_PATH.unshift '#{File.expand_path('lib')}'
begin
  require "cairn"
  StandaloneMigrations::Tasks.load_tasks
rescue LoadError => e
  puts "gem install cairn to get db:migrate:* tasks! (Error: \#{e})"
end
TXT
  end

  def before_cmd_actions
    StandaloneMigrations::Configurator.instance_variable_set(:@env_config, nil)
    `rm -rf test/tmp` if File.exist?('test/tmp')
    `mkdir test/tmp`
    write_rakefile
    write(schema, '')
    write 'db/config.yml', <<-TXT
development:
  adapter: sqlite3
  database: db/development.sql
test:
  adapter: sqlite3
  database: db/test.sql
production:
  adapter: sqlite3
  database: db/production.sql
    TXT
  end

  # runs a command
  def run_cmd(cmd)
    result = `#{cmd} 2>&1`
    raise result unless $?.success?
    result
  end

end
