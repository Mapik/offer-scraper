require_relative '../lib/motoads.rb'

#------------------------------------------------------------------
LOGGER.create_log('info', "Start new session...")
scrape_session = Session.new()

LOGGER.create_log('info', "Connect to db...")
DB_CONN = DbConnection.new(MP_USER, MOTOADS_DB)

LOGGER.create_log('info', "Save session details...")
sql = "INSERT INTO dta.scrape_session_details(
            session_guid, start_time, end_time, type)
    		VALUES ('#{scrape_session.session_guid}', '#{scrape_session.session_start_time}', null, 'links');"
DB_CONN.exec_sql(sql)

#------------------------------------------------------------------
LOGGER.create_log('info', "Retrieve Configuration...")
sql = "select * from config.sites;"
config_rs = DB_CONN.exec_sql(sql)
OTOMOTO_PARAMS['min_id'] = last_otomoto_id #potrzeba sporego refaktoringu, co tyczy się całego tego kodu!!!
LOGGER.create_log('info', "Final OTOMOTO_PARAMS: #{OTOMOTO_PARAMS}")

#------------------------------------------------------------------
LOGGER.create_log('info', "Retrieve number of pages...")
config_rs.each do |crs|
	LOGGER.create_log('info', "Open page code: #{crs["code"]}")
	page_with_offers = SiteToScrape.new(crs["url"], crs["code"])
	
	LOGGER.create_log('info', "#{crs["code"]}: get number of pages...")
	pager = extract_pages(page_with_offers.page, page_with_offers.code)
	page_with_offers.get_number_of_pages(pager)
	LOGGER.create_log('info', "#{crs["code"]}: new pages with links: #{page_with_offers.n_pages}")
	
end

#------------------------------------------------------------------
LOGGER.create_log('info', "Extract links...")

sts = []

ObjectSpace.each_object(SiteToScrape) do |x| 
	if x.n_pages.class != String
		sts << x		
	end
end 

sts.each do |s| 
	n_pages = s.n_pages
	LOGGER.create_log('info', "Extracting page: #{s.code}")
	#(150..n_pages).each do |p|
	(1..n_pages).each do |p|
		LOGGER.create_log('info', "Extracting page: #{p}")
		pwo = PageWithOffers.new(s.url, s.code, p)
		offer_links = extract_links(pwo.page, s.code)
		offer_links.each do |link|
			offer_guid = SecureRandom.uuid
			tdy = Time.now
			sql = "INSERT INTO dta.offer_links VALUES('#{scrape_session.session_guid}','#{offer_guid}','#{link['href']}','#{tdy}',0,'#{s.code}', 0)"
			DB_CONN.exec_sql(sql)		
		end
		#sleep 1.0 + rand	
	end
end 

sql = "UPDATE dta.scrape_session_details SET end_time = '#{Time.now}' where session_guid = '#{scrape_session.session_guid}'"
DB_CONN.exec_sql(sql)
LOGGER.create_log('info', "End of session: #{scrape_session.session_guid}")