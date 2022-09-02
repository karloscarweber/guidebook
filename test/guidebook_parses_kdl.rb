require 'test_helper'
require 'fileutils'

# $:.unshift File.dirname(__FILE__) + '/../' # I think this will let us see db folder

begin
  ENV["environment"] = "development"
  load File.expand_path('../apps/parsekdl.rb', __FILE__)

  # def stand_up_db
  #   ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
  # end

  class ParseKDL::Test < TestCase

    Page = ParseKDL::Models::Page
    def nuke_db
      Page.new(title: "Hiking", content: "Fishing").save
      Page.all.each(&:delete)
    end

    def setup
      # @config = Camping::GuideBook.get_config
      @kdl = Camping::GuideBook.parse_kdl("db/config.kdl")
    end

    # Test that we parsed kdl
    def test_that_we_parse_kdl
      assert_equal 'KDL::Document', @kdl.class.to_s, "The returned object is nil, or at least it's not of class KDL::Document"
    end

    # Test that we parsed the right data.
    def test_that_we_parsed_the_right_data
      # kdl_class.to_s == 'KDL::Document'
      assert false, "You did not write the test yet."
    end

    # tests if we can set the file location for our kdl file, and then get that file.

  end
rescue MissingLibrary
  warn "Skipping migration tests"
end
