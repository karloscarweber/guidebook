require 'test_helper'

ENV["environment"] = "development"

# $:.unshift File.dirname(__FILE__) + '/../../' # I think this will let us see db folder

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
    before_cmd_actions()
    @test_string = "whatever"
  end

  it "should just expect something to be true." do
    _(@test_string).must_equal "whatever"
  end
end
