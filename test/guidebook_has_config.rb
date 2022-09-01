require 'test_helper'
require 'fileutils'

# $:.unshift File.dirname(__FILE__) + '/../' # I think this will let us see db folder

begin
  ENV["environment"] = "development"
  load File.expand_path('../apps/has_config.rb', __FILE__)

  # def stand_up_db
  #   ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
  # end
  Page = HasConfig::Models::Page
  def nuke_db
    Page.new(title: "Hiking", content: "Fishing").save
    Page.all.each(&:delete)
  end

  class HasConfig::Test < TestCase

    def setup
      @configs = Camping::GuideBook.get_config
      @options = HasConfig.options
      @home_dir = Dir.pwd
    end

    # restores the directory defaults.
    # call at the beginning of a test.
    def restore_defaults

    end

    def test_has_correct_settings
      # puts @configs
      assert_equal @configs[:development][:adapter],  @options[:adapter],  "Database adapter does not match the expected settings: #{@options}"
      assert_equal @configs[:development][:host],     @options[:db_host],  "Database host does not match the expected settings: #{@options}"
      assert_equal @configs[:development][:database], @options[:database], "Database database name does not match the expected settings: #{@options}"
      assert_equal @configs[:development][:pool],     @options[:pool],     "Database pool does not match the expected settings: #{@options}"
    end

    # tests if we can set the file location for our kdl file, and then get that file.

    # First find the root config file with no pattern. Prioritizes the root config
    # found in db/config.kdl instead of any deeper kdl file.
    def test_can_find_config_file
      config_file = Camping::GuideBook.get_config_file
      assert_equal "db/config.kdl", config_file, "The config file was not found. #{config_file}"
    end

    # Next find the root config file when provided with a search pattern
    def test_can_find_config_file_when_provided_with_search_pattern
      config_file = Camping::GuideBook.get_config_file "db/*.kdl"
      assert_equal "db/config.kdl", config_file, "The config file was not found. #{config_file}"
    end

    # Next find the root config file.
    def test_can_find_config_file_when_provided_with_test_search_pattern
      config_file = Camping::GuideBook.get_config_file "test/**/db/*.kdl"
      assert_equal "test/apps/db/config.kdl", config_file, "The config file was not found. #{config_file}"
    end

    # tests if we can override the default settings in the Camping Startup.
    # def test_can_override_setttings
    #   HasConfig.pack Camping::GuideBook
    # end

  end
rescue MissingLibrary
  warn "Skipping migration tests"
end