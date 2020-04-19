require "./lib/motoads.rb"
#require "config_evn_test.rb"
require "test/unit"

class TestMyLogger < Test::Unit::TestCase
	def test_create_log
    logger = MyLogger.new
    assert logger.create_log('info','testowe info')
    assert logger.create_log('fatal','testowe fatal')
    assert logger.create_log('error','testowe error')
    assert logger.create_log('warn','testowe warn')
    assert logger.create_log('debug','testowe debug')
  end
end


