require 'test_helper'

begin
  # load File.expand_path('../apps/migrations.rb', __FILE__)

  # ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

  # class Migrations::Test < TestCase
  #   def test_create
  #     Migrations.create
  #   end
  #
  # # test if we load the migration options into rack.
  #   def test_that_we_load_into_rack
  #     assert false, "Test not written yet."
  #   end
  # end
rescue MissingLibrary
  warn "Skipping migration tests"
end
