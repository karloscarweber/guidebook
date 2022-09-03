require 'test_helper'

begin
  load File.expand_path('../apps/doesqueries.rb', __FILE__)

  def stand_up_db
    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
  end
  Page = Doesqueries::Models::Page
  def nuke_db
    Page.new(title: "Hiking", content: "Fishing").save
    Page.all.each(&:delete)
  end
  # Stand up a whole camping app here:

  stand_up_db

  class Doesqueries::Test < TestCase

    def test_model_nukes_data
      nuke_db
      all_pages = Page.all
      assert((all_pages.count == 0), "Far more than one page was found. Count: #{all_pages.count}")
    end

    def test_model_saves_data
      nuke_db
      new_page = Page.new(title: "Hiking", content: "fishing").save
      assert(new_page, "Page was not saved. The ID was something else: #{new_page}.")
    end

    def test_model_deletes_data
      nuke_db
      new_page = Page.new(title: "Cheese", content: "crackers")
      new_page.save
      possible_page = Page.find_by_title "Cheese"

      refute(possible_page == nil, "New page was empty when it should not have been. That means that it didn't save.. #{possible_page}")

      possible_page.delete
      deleted_page = Page.find_by_title "Cheese"
      assert(deleted_page == nil, "New page was there when it should have been deleted. that means that it didn't save.. #{deleted_page}")
    end

  end
rescue
  warn "Skipping Does Queries tests"
end
