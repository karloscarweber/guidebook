require 'test_helper'

ENV["environment"] = "development"

$:.unshift File.dirname(__FILE__) + '../'

# Camping.goes :CommandLine
module CommandLine
end

# module CommandLine
#   pack Camping::GuideBook
# end
# module CommandLine
#   module Models
#     class Page < Base; end
#   end
# end

describe "command line stuff" do
  include CommandLineCommands

  before do
    move_to_tmp
  end

  after do
    leave_tmp
  end

  # Test install command
  it "should install stuff when executed" do
    run_cmd("ruby ../../bin/guidebook install")
    database_folder = Dir.glob("db")
    _(database_folder.empty?).must_equal false
    sub_folder = Dir.glob("db/*")
    _(sub_folder.include?("db/migrate")).must_equal true, "Does not inlcude migrate, #{sub_folder}"
    _(sub_folder.include?("db/config.kdl")).must_equal true, "Does not inlcude config.kdl, #{sub_folder}"
    _(Dir.glob("*").include?('Rakefile')).must_equal true, "Does not inlcude config.kdl, Rakefile"
  end

  it "should show the version" do
    _(run_cmd("ruby ../../bin/guidebook -v")).must_equal "Guidebook v#{Camping::GuideBook::VERSION}\n"
  end

  it "should respect a change in directory option" do
    run_cmd("ruby ../../bin/guidebook install -d campcamp")
    database_folder = Dir.glob("campcamp")
    _(database_folder.empty?).must_equal false
  end

  it "should append database details to the rakefile" do
    run_cmd("ruby ../../bin/guidebook install")
    splitted = File.open('Rakefile').read.split("\n")
    assert_equal '  require "cairn"', splitted[3], "This is the wrong stuff appended to Rakefile."
    assert_equal '  StandaloneMigrations::Tasks.load_tasks', splitted[4], "This is the wrong stuff appended to Rakefile."
  end

end
