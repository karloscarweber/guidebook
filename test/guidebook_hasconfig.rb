require 'test_helper'

begin

  ENV["environment"] = "development"

  $:.unshift File.dirname(__FILE__) + '../../'

  class TestHasConfig < MiniTest::Test
    include TestCaseReloader
    include CommandLineCommands
    BASE = File.expand_path('../apps/hasconfig', __FILE__)
    def file; BASE + '.rb' end

    def setup
      set_name :HasConfig
      move_to_tmp()
      write_rakefile()

      # the Camping reloader runs from the root for some reason,
      # so when we reload a camping app we need to give it the current
      # test/tmp directory as the location of the database, otherwise
      # we'll create databases in the root of Guidebook which is not
      # what we want.
      db_loc = Dir.pwd
      write_good_kdl(db_loc)
      super
      @configs = Camping::GuideBook.get_config
      @options = HasConfig.options
    end

    def teardown
      leave_tmp()
      super
    end

    # expect it to have the correct settings.
    # This includes overwriting some settings when a setting is set.
    def test_has_correct_settings
      assert_equal @configs[:development][:adapter],  @options[:adapter],  "Database adapter does not match the expected settings: #{@options}"
      assert_equal 'outerspace', @options[:host],  "Database host does not match the expected settings: #{@options}"
      assert @options[:host] != 'localhost',  "Database host does not match the expected settings: #{@options}"
      assert_equal @configs[:development][:database], @options[:database], "Database database name does not match the expected settings: #{@options}"
      assert_equal @configs[:development][:pool],     @options[:pool],     "Database pool does not match the expected settings: #{@options}"
    end

    # tests if we can set the file location for our kdl file, and then get that file.

    # First find the root config file with no pattern. Prioritizes the root config
    # found in db/config.kdl instead of any deeper kdl file.
    def test_can_find_config_file
      config_file = Camping::GuideBook.get_config_file
      assert_equal "db/config.kdl", config_file, "The config file was not found #{config_file}"
    end

    # Next find the root config file when provided with a search pattern
    def test_can_find_config_file_when_provided_with_search_pattern
      config_file = Camping::GuideBook.get_config_file "db/*.kdl"
      assert_equal "db/config.kdl", config_file, "The config file was not found #{config_file}"
    end

    # Next find the root config file.
    def test_can_find_config_file_when_provided_with_test_search_pattern
      config_file = Camping::GuideBook.get_config_file "db/*.kdl"
      assert_equal "db/config.kdl", config_file, "The config file was not found. #{config_file}"
    end

    # tests if we can override the default settings in the Camping Startup.
    def test_can_override_setttings
      HasConfig.set :database, "database_url"
      HasConfig.pack Camping::GuideBook

      assert_equal 'database_url', HasConfig.options[:database], "Settings were not overwritten in the module definition as expectd."

      assert_equal 'outerspace', HasConfig.options[:host], "Settings were not overwritten in the module definition as expectd."
    end

  end
rescue => error
  warn ""
  warn "# Skipping Has Config tests"
  warn ""
  warn error
  warn ""
end
