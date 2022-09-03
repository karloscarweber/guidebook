require 'test_helper'
require 'fileutils'

begin
  ENV["environment"] = "development"
  load File.expand_path('../apps/has_config.rb', __FILE__)

  class HasConfig::Test < TestCase

    def setup
      @configs = Camping::GuideBook.get_config
      @options = HasConfig.options
    end

    # expec it to have the correct settings.
    def test_has_correct_settings
      assert_equal @configs[:development][:adapter],  @options[:adapter],  "Database adapter does not match the expected settings: #{@options}"
      assert_equal @configs[:development][:host],     @options[:host],  "Database host does not match the expected settings: #{@options}"
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
    def test_can_override_setttings
      # HasConfig.set :database, "database_url"
      # HasConfig.pack Camping::GuideBook
      assert false, "Test not written yet."
    end

  end
rescue MissingLibrary
  warn "Skipping Has Config tests"
end
