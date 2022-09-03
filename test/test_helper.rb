$:.unshift File.dirname(__FILE__) + '/../lib'
$:.unshift File.dirname(__FILE__) + '/../' # I think this will let us see db folder

# test_helper.rb
begin
  require 'rubygems'
rescue LoadError
end

require 'camping'
require 'minitest/autorun'
require 'minitest'
require 'minitest/spec'
require 'rack/test'
require "minitest/reporters"
require_relative '../lib/guidebook.rb'
require 'fileutils'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

class TestCase < MiniTest::Test
  include Rack::Test::Methods

  def self.inherited(mod)
    mod.app = Object.const_get(mod.to_s[/\w+/])
    super
  end

  class << self
    attr_accessor :app
  end

  def body() last_response.body end
  def app()  self.class.app     end

  def assert_reverse
    begin
      yield
    rescue Exception
    else
      assert false, "Block didn't fail"
    end
  end

  def assert_body(str)
    case str
    when Regexp
      assert_match(str, last_response.body.strip)
    else
      assert_equal(str.to_s, last_response.body.strip)
    end
  end

  def assert_status(code)
    assert_equal(code, last_response.status)
  end

  def test_silly; end

end

# def stand_up_db
#   ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
# end
# Page = Doesqueries::Models::Page
# def nuke_db
#   Page.new(title: "Hiking", content: "Fishing").save
#   Page.all.each(&:delete)
# end
# # Stand up a whole camping app here:
