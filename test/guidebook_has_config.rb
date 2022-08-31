require 'test_helper'
require 'fileutils'

# $:.unshift File.dirname(__FILE__) + '/../' # I think this will let us see db folder

begin
  ENV["environment"] = "development"
  load File.expand_path('../apps/has_config.rb', __FILE__)

  # def stand_up_db
  #   ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
  # end
  Page = HasConfig::Models::Page
  def nuke_db
    Page.new(title: "Hiking", content: "Fishing").save
    Page.all.each(&:delete)
  end

  class HasConfig::Test < TestCase

    def setup
      @configs = Camping::GuideBook.get_config
      @options = HasConfig.options
      puts @configs[:development][:host]
      puts @options[:db_host]
      # puts @options
    end

    def test_has_correct_settings
      puts @configs
      assert_equal @configs[:development][:adapter],  @options[:adapter],  "Database adapter does not match the expected settings: #{@options}"
      assert_equal @configs[:development][:host],  @options[:db_host],  "Database host does not match the expected settings: #{@options}"
      assert_equal @configs[:development][:database], @options[:database], "Database database name does not match the expected settings: #{@options}"
      assert_equal @configs[:development][:pool],     @options[:pool],     "Database pool does not match the expected settings: #{@options}"
    end

  end
rescue MissingLibrary
  warn "Skipping migration tests"
end
