require "camping"
require_relative '../../lib/guidebook.rb'

Camping.goes :Packedup

module Packedup
  pack Camping::GuideBook
end
