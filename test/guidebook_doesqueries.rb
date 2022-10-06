require 'test_helper'

begin

  $:.unshift File.dirname(__FILE__) + '../../'

  ENV["environment"] = "development"

  class TestDoesqueries < MiniTest::Test
    include TestCaseReloader
    include CommandLineCommands
    BASE = File.expand_path('../apps/doesqueries', __FILE__)
    def file; BASE + '.rb' end

    def setup
      set_name :Doesqueries
      move_to_tmp()
      write_rakefile()

      # the Camping reloader runs from the root for some reason,
      # so when we reload a camping app we need to give it the current
      # test/tmp directory as the location of the database, otherwise
      # we'll create databases in the root of Guidebook which is not
      # what we want.
      db_loc = Dir.pwd
      write_good_kdl(db_loc)
      super
      run_make_db()
    end

    def teardown
      Doesqueries::Models::Page.all.each(&:delete)
      leave_tmp()
      super
    end

    def test_model_nukes_data_between_tests
      all_pages = Doesqueries::Models::Page.all
      assert((all_pages.count == 0), "Far more than one page was found. Count: #{all_pages.count}")
    end

    def test_model_saves_data
      new_page = Doesqueries::Models::Page.new(title: "Hiking", content: "fishing").save
      assert(new_page, "Page was not saved. The ID was something else: #{new_page}.")
    end

    def test_model_deletes_data
      new_page = Doesqueries::Models::Page.new(title: "Cheese", content: "crackers")
      new_page.save
      possible_page = Doesqueries::Models::Page.find_by_title "Cheese"

      refute(possible_page == nil, "New page was empty when it should not have been. That means that it didn't save.. #{possible_page}")

      possible_page.delete
      deleted_page = Doesqueries::Models::Page.find_by_title "Cheese"
      assert(deleted_page == nil, "New page was there when it should have been deleted. that means that it didn't save.. #{deleted_page}")
    end

  end
rescue => error
  warn "Skipping Does Queries tests #{error}"
end
