require 'test_helper'

ENV["environment"] = "development"

# $:.unshift File.dirname(__FILE__) + '/../'

Camping.goes :CommandLine

module CommandLine
  pack Camping::GuideBook
end
module CommandLine
  module Models
    class Page < Base; end
  end
end

# class CommandLine::Test < TestCase
#
#   def setup
#     # nuke the test directory if it exists
#   end
#
#   # Test that we can run the install command in a camping project.
#   # def test_full_command_line_install
#   test "test_full_command_line_install" do
#     # Move to a new directory to work our magic.
#     # run the install command
#     # check for the files and folders
#     assert false, "Test not written yet."
#   end
#
# end

describe "command line stuff" do
  include ComandLineCommands

  before do
    @original_dir = Dir.pwd
    Dir.chdir "test"
    Dir.mkdir("tmp") unless Dir.exist?("tmp")
    Dir.chdir "tmp"
  end

  after do
    Dir.chdir @original_dir
    `rm -rf test/tmp` if File.exist?('test/tmp')
  end

  # Test install command
  it "should install stuff when executed" do
    run_cmd("ruby ../../bin/guidebook install")
    database_folder = Dir.glob("db")
    _(database_folder.empty?).must_equal false
    sub_folder = Dir.glob("db/*")
    _(sub_folder.include?("db/migrate")).must_equal true, "Does not inlcude migrate, #{sub_folder}"
    _(sub_folder.include?("db/config.kdl")).must_equal true, "Does not inlcude config.kdl, #{sub_folder}"
    # check to see if a rake file, found in tmp in this instance, includes an additional rake command that we add.
  end

  it "should show the version" do
    _(run_cmd("ruby ../../bin/guidebook -v")).must_equal "Guidebook v#{Camping::GuideBook::VERSION}\n"
  end

  it "should respect a change in directory option" do
    run_cmd("ruby ../../bin/guidebook install -d campcamp")
    database_folder = Dir.glob("campcamp")
    _(database_folder.empty?).must_equal false
  end

end
