# test/apps/parseskdl.rb

# $:.unshift File.dirname(__FILE__) + '/../../' # I think this will let us see db folder

Camping.goes :ParseKDL

module ParseKDL
  pack Camping::GuideBook
end
module ParseKDL
  module Models
    class Page < Base; end
  end
end
