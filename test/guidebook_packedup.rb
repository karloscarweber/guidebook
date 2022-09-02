require 'test_helper'
require 'fileutils'

begin
  load File.expand_path('../apps/packedup.rb', __FILE__)

  # ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

  class Packedup::Test < TestCase

    # Test if the gear was even packed
    def test_gear_was_packed
      assert_equal("Camping::GuideBook", app.gear[0].name, "Here is the packed gear: #{app.gear}.")
    end

    # No Options were added so let's see if it's all good here.
    def test_default_options_were_loaded
      assert_equal("localhost", app.options[:host], "The host is wrong: #{app.options[:host]}")
      assert_equal("sqlite3", app.options[:adapter], "The adapter is wrong: #{app.options[:adapter]}")
      assert_equal("db/camping.db", app.options[:database], "The default database is wrong: #{app.options[:database]}")
      assert_equal(5, app.options[:pool], "the datasbase pool value is wrong: #{app.options[:pool]}")
    end

  end
rescue MissingLibrary
  warn "Skipping PackedUP tests"
end
