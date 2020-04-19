require_relative '../lib/motoads.rb'

LOGGER.create_log('info', "Start new session...")
scrape_session = Session.new()

LOGGER.create_log('info', "Connect to db...")
db_conn = DbConnection.new(MP_USER, MOTOADS_DB)

LOGGER.create_log('info', "Save session details...")
sql = "INSERT INTO dta.scrape_session_details(
            session_guid, start_time, end_time, type)
    		VALUES ('#{scrape_session.session_guid}', '#{scrape_session.session_start_time}', null, 'offers');"
db_conn.exec_sql(sql)

LOGGER.create_log('info', "Get offer links...")
sql = "select offer_guid, link, code from dta.offer_links where is_visited = 0 and n_errors = 0 and substring(link,8,7)!='allegro' --LIMIT 1;" #!!!!!!!!
links_rs = db_conn.exec_sql(sql)

LOGGER.create_log('info', "Extract offers...")
LOGGER.create_log('info', "N Offers: #{links_rs.ntuples}")
i = 0
links_rs.each do |l|
	LOGGER.create_log('info', "Offer number: #{i += 1}")
	
	offer_page = OfferPage.new(l["link"], l["offer_guid"], l["code"])
	LOGGER.create_log('info', "Offer #{offer_page.guid}: #{offer_page.url}")


	LOGGER.create_log('info', "Offer #{offer_page.guid}: create subpage")
	offer = offer_page.make_offer_subpage
	
	# LOGGER.create_log('info', "Offer #{offer_page.guid}: save html")
	# offer.save_offer_html
	
	LOGGER.create_log('info', "Offer #{offer_page.guid}: extract meta items")
	offer.extract_meta_items
	
	LOGGER.create_log('info', "Offer #{offer_page.guid}: extract params")
	offer.extract_params
	
	LOGGER.create_log('info', "Offer #{offer_page.guid}: extract features")
 	offer.extract_features
	
	LOGGER.create_log('info', "Offer #{offer_page.guid}: extract seller")
	offer.extract_seller
	
	LOGGER.create_log('info', "Offer #{offer_page.guid}: extract price")
	offer.extract_price

	# LOGGER.create_log('info', "Offer #{offer_page.guid}: save json")
	# offer.save_offer_json
	
	#LOGGER.create_log('info', "Offer #{offer_page.guid}: extract picture")
	#offer.extract_picture_url
	
	#LOGGER.create_log('info', "Offer #{offer_page.guid}: save picture")
	#offer.save_picture
	
	LOGGER.create_log('info', "Offer #{offer_page.guid}: prepare save sql")
	offer.prepare_save_sql(scrape_session.session_guid)
	
	LOGGER.create_log('info', "Offer #{offer_page.guid}: execute save sql")
	db_conn.exec_sql(offer.save_sql)

	LOGGER.create_log('info', "Offer #{offer_page.guid}: execute update sql")
	offer.prepare_update_sql(scrape_session.session_guid)
	db_conn.exec_sql(offer.update_sql)
	
	LOGGER.create_log('info', "Offer #{offer_page.guid}: END")
	#sleep 1.0 + rand
end

sql = "UPDATE dta.scrape_session_details SET end_time = '#{Time.now}' where session_guid = '#{scrape_session.session_guid}'"
db_conn.exec_sql(sql)
LOGGER.create_log('info', "End of session: #{scrape_session.session_guid}")