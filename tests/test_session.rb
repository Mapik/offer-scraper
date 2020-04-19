require "./lib/motoads.rb"
require "test/unit"

class TestSession < Test::Unit::TestCase
	def test_create_session
		$LOGGER = MyLogger.new
		s = Session.new()
		assert s
	end
	
	
end