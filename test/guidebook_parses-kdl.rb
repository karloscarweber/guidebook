require 'test_helper'

ENV["environment"] = "development"

$:.unshift File.dirname(__FILE__) + '../../'

module ParseKDL
end

class ParseKDL::Test < TestCase
  include CommandLineCommands

  def setup
    move_to_tmp()

    write_good_kdl
    write_bad_kdl

    @kdl = Camping::GuideBook.parse_kdl("db/config.kdl")
    @test_config_1 = {default: {database: "kow"}}
    @test_config_2 = {default: {database: "db/camping.db", host: "localhost", adapter: "sqlite3"}}
    @test_config_3 = {production: {adapter: "postgres",database: "kow"}}
    @test_config_1_loc = 'db/test_config_1.yml'
    @test_config_2_loc = 'db/test_config_2.yml'
    @test_config_3_loc = 'db/test_config_3.yml'
  end

  def teardown
    leave_tmp()
  end

  # Test that we parsed kdl
  def test_that_we_parse_kdl
    assert_equal 'KDL::Document', @kdl.class.to_s, "The returned object is nil, or at least it's not of class KDL::Document"
  end

  def test_that_we_get_an_error_when_the_kdl_is_bad
    Camping::GuideBook.parse_kdl("db/bad.kdl", true)
    last_warning = Camping::GuideBook::WARNINGS.last
    test_string = <<-RUBY
\n2:   default adapter="sqlite3" database="db/camping.db" host="localhost" pool=5 timeout=5000
3:   development
4:   production adapter="postgres" database="kow"
5: }
6:\s
RUBY
    assert_equal test_string, last_warning, "Error messages written are not what we expected."
  end

  # def test_that_we_get_the_right_error_when_the_kdl_is_bad
  #   assert false, "Test not written yet."
  # end

  # Test that we parsed the right data.
  # It's unmerged with our default settings.
  def test_that_we_parsed_the_right_data
    settings = Camping::GuideBook.map_kdl(@kdl)
    # puts settings
    assert_equal 'sqlite3', settings[:default][:adapter], "Adapter wrong in unmerged settings."
    assert_equal 'db/camping.db', settings[:default][:database], "Database wrong in unmerged settings."
    assert_equal 'localhost', settings[:default][:host], "Host wrong in unmerged settings."
    assert_equal 5, settings[:default][:pool], "Pool wrong in unmerged settings."
    assert_equal 5000, settings[:default][:timeout], "Timeout wrong in unmerged settings."
    assert settings[:development].empty?, "Development settings were supposed to be empty. WTF!"
    assert_equal 'postgres', settings[:production][:adapter], "Adapter wrong unmerged settings."
    assert_equal 'kow', settings[:production][:database], "Database wrong unmerged settings."
  end

  def test_that_we_generate_the_main_yaml_from_kdl

    app = Tent.new

    config_dict = Camping::GuideBook.squash_settings(app)
    host, adapter, database, pool = config_dict[:collapsed_config]

    length = Camping::GuideBook.generate_config_yml(config_dict[:stored_config], 'db/config.yml')
    assert_equal 433, length, "Yammy is not the same"

    splitted = File.open('db/config.yml').read.split("\n")
    assert_equal "  adapter: sqlite3", splitted[6], "The Generated YAML for test_config_1 doesn't have the right data. Not Ok."
  end

  def test_that_we_generate_the_right_yaml
    # test the first config
    length = Camping::GuideBook.generate_config_yml(@test_config_1, @test_config_1_loc)
    assert_equal 162, length, "The Generated YAML for test_config_1 is too long #{length}. Which means it's wrong."

    splitted = File.open(@test_config_1_loc).read.split("\n")
    assert_equal "default: ", splitted[5], "The Generated YAML for test_config_1 doesn't have the right data. Not Ok."
  end

  def test_that_we_generate_the_right_yaml_again
    length = Camping::GuideBook.generate_config_yml(@test_config_2, @test_config_2_loc)
    assert_equal 209, length, "The Generated YAML for test_config_2 is too long #{length}. Which means it's wrong."

    splitted = File.open(@test_config_2_loc).read.split("\n")
    assert_equal "  adapter: sqlite3", splitted[6], "The Generated YAML for test_config_2 doesn't have the right data. Not Ok."
    assert_equal "  database: db/camping.db", splitted[7], "The Generated YAML for test_config_2 doesn't have the right data. Not Ok."
    assert_equal "  host: localhost", splitted[8], "The Generated YAML for test_config_2 doesn't have the right data. Not Ok."
  end

  def test_that_we_generate_the_right_yaml_final_final_v3
    length = Camping::GuideBook.generate_config_yml(@test_config_3, @test_config_3_loc)
    assert_equal 185, length, "The Generated YAML for test_config_3 is too long #{length}. Which means it's wrong."

    splitted = File.open(@test_config_3_loc).read.split("\n")
    assert_equal "  adapter: postgres", splitted[6], "The Generated YAML for test_config_3 doesn't have the right data. Not Ok."
    assert_equal "  database: kow", splitted[7], "The Generated YAML for test_config_3 doesn't have the right data. Not Ok."
  end

end
