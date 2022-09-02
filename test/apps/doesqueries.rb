# doesqueries.rb
require "camping"
require_relative '../../lib/guidebook.rb'

$:.unshift File.dirname(__FILE__) + '/../../' # I think this will let us see db folder

Camping.goes :Doesqueries

module Doesqueries

  set :database, 'db/camping.db'
  set :host, 'localhost'

  pack Camping::GuideBook
end
module Doesqueries
  module Models
    class Page < Base; end
  end
end
