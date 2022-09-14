require 'test_helper'

$:.unshift File.dirname(__FILE__) + '../../'

begin

  Camping.goes :Packedup
  Packedup.pack(Camping::GuideBook)

  class Packedup::Test < TestCase
    include CommandLineCommands

    def setup
      move_to_tmp()

      write_good_kdl
      write_bad_kdl

      # load File.expand_path('../apps/parseskdl.rb', __FILE__)
      # Dir.mkdir("db") unless Dir.exist?("db")

      # Camping.goes :Packedup
      # Packedup.pack(Camping::GuideBook)

    end

    def teardown
      leave_tmp()
    end

    # Test if the gear was even packed
    def test_gear_was_packed
      assert_equal("Camping::GuideBook", app.gear[0].name, "Here is the packed gear: #{app.gear}.")
    end

    # No Options were added so let's see if it's all good here.
    def test_default_options_were_loaded
      assert_equal("localhost", app.options[:host], "The host is wrong: #{app.options[:host]}")
      assert_equal("sqlite3", app.options[:adapter], "The adapter is wrong: #{app.options[:adapter]}")
      assert_equal("db/camping.db", app.options[:database], "The default database is wrong: #{app.options[:database]}")
      assert_equal(5, app.options[:pool], "the database pool value is wrong: #{app.options[:pool]}")
    end

  end
rescue => error
  warn "Skipping PackedUP tests: "
  warn "  Error: #{error}"
end
