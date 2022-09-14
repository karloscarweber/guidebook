# doesqueries.rb
require "camping"
require_relative '../../lib/guidebook.rb'

# $:.unshift File.dirname(__FILE__) + '/../../' # I think this will let us see db folder

Camping.goes :HasConfig

module HasConfig

  # host      = app.options[:host]      ||=  host
  # adapter   = app.options[:adapter]   ||=  adapter
  # database  = app.options[:database]  ||=  database
  # pool      = app.options[:pool]      ||=  pool

  set :host, "outerspace"
  pack(Camping::GuideBook)
end
module HasConfig
  module Models
    class Page < Base; end
  end
end
