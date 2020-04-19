require "./lib/motoads.rb"
require "test/unit"

class TestActiveOffers < Test::Unit::TestCase

  def test_create_active_offers
    puts "test_create_active_offers"
		sql = 	"select 
								ol.offer_guid
								,ol.link
								,opp.is_active
								,ol.code
						from dta.offer_links ol
						inner join dta.offer_params_pivot opp
						on ol.offer_guid = opp.offer_guid
						limit 2;"
    ao = ActiveOffers.new(sql)
    assert ao
  end

  # def test_get_active_offers
  # 	puts "test_get_active_offers"
  #   ao = ActiveOffers.new()
		# sql = 	"select 
		# 						ol.offer_guid
		# 						,ol.link
		# 						,opp.is_active
		# 						,ol.code
		# 				from dta.offer_links ol
		# 				inner join dta.offer_params_pivot opp
		# 				on ol.offer_guid = opp.offer_guid
		# 				limit 2;"
  #   assert ao.get_active_offers(sql)
  # end

  def test_check_if_active
    puts "test_check_if_active"
		sql = 	"select 
								ol.offer_guid
								,ol.link
								,opp.is_active
								,ol.code
						from dta.offer_links ol
						inner join dta.offer_params_pivot opp
						on ol.offer_guid = opp.offer_guid
						limit 2;"
    ao = ActiveOffers.new(sql)
    ao.check_if_active
    assert ao
  end



end
