# doesqueries.rb
require "camping"
require_relative '../../lib/guidebook.rb'

# $:.unshift File.dirname(__FILE__) + '/../../test/tmp/' # I think this will let us see db folder

Camping.goes :Doesqueries

module Doesqueries

  # set :database, 'test/tmp/db/camping.db'
  set :host, 'localhost'

  pack Camping::GuideBook

  module Models
    class Page < Base; end
  end

  def self.create
    establish_connection()
  end
end
