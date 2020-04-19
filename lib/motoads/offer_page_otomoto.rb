class OfferPageOtomoto #< OfferPage
	
	include SaveData

	attr_reader :guid, :url, :offer_date, :offer_id, :save_sql, :update_sql, :offer_message, :is_active

	def initialize(url, guid)
		@url = url
		@guid = guid
		@scrape_time = Time.now
		@is_error = 0

		begin
			@response = RestClient.get(url)
			@page = Nokogiri::HTML(@response)
		rescue StandardError => e
			@is_error += 1
			@response = nil
			@page = nil
		end
	end

	def extract_meta_items
		begin
			meta_items = extract_data(@page, "span.offer-meta__value")
			@offer_date = meta_items[0].text
			@offer_id = meta_items[1].text
		rescue StandardError => e
			@is_error += 1
			LOGGER.create_log('error', "Offer #{@guid}: no meta_items: #{e}")
		end
	end

	def extract_price
		begin
			price_type = extract_data(@page, "span.offer-price__details")
			price_value = extract_data(@page, "span.offer-price__number")
			price_currency = extract_data(@page, "span.offer-price__currency")
			@price_type = price_type[0].text
			@price_value = price_value[0].text.strip.gsub('PLN','').gsub(' ', '')
			@price_currency = price_currency[0].text
		rescue StandardError => e
			@is_error += 1
			LOGGER.create_log('error', "Offer #{@guid}: no price_data: #{e}")
		end
	end

	def extract_params
		begin
			offer_param = extract_data(@page, "li.offer-params__item")
			@offer_params_hash = {}
			offer_param.each do |item|
				param_label = extract_data(item, "span").text.strip
				param_value = extract_data(item, "div").text.strip
				@offer_params_hash[param_label] = param_value
			end
		rescue StandardError => e
			@is_error += 1
			LOGGER.create_log('error', "Offer #{@guid}: no meta_items: #{e}")
		end
	end

	def extract_features
		begin
			offer_features = extract_data(@page, "li.offer-features__item")
			@offer_features_ary = []
			offer_features.each do |f|
				@offer_features_ary << f.text.strip
			end
		rescue StandardError => e
			@is_error += 1
			LOGGER.create_log('error', "Offer #{@guid}: no offer_features: #{e}")
		end
	end

	def extract_seller
		begin
			seller_type = extract_data(@page, 'small.seller-box__seller-type').first
			seller_name = extract_data(@page, 'h2.seller-box__seller-name').first
			seller_address = extract_data(@page, 'span.seller-box__seller-address__label').first
			seller_full_offer = extract_data(@page, 'a#linkToUser').first

			seller_type = seller_type.text.strip
			seller_name = seller_name.text.strip
			seller_address = seller_address.text.strip.gsub(' ','| ').gsub(' |','|').gsub('|','')

			if !seller_full_offer.nil? 
				seller_full_offer = seller_full_offer['href']
			end 

			@seller_hash ={
			  "seller_type" => seller_type,
			  "seller_name" => seller_name,
			  "seller_address" => seller_address,
			  "seller_full_offer" => seller_full_offer
			}
		rescue StandardError => e
			@is_error += 1
			LOGGER.create_log('error', "Offer #{@guid}: no offer_seller: #{e}")
		end
	end

	def extract_picture_url
		begin
			@pict_url = extract_data(@page, 'img.bigImage').first['src']	
		rescue StandardError => e
			@is_error += 1
			LOGGER.create_log('error', "Offer #{@guid}: no pict_url: #{e}")
		end
	end

	def prepare_save_sql(session_guid)
		begin
			@save_sql = ''
			@save_sql += "INSERT INTO dta.offer_details(
										            session_guid, offer_guid, scrape_time, offer_id, offer_date)
										    VALUES ('#{session_guid}', '#{@guid}', '#{@scrape_time}', '#{@offer_id}', '#{@offer_date}');"
	    
			@offer_params_hash.each_pair do |pn, pv|
				@save_sql += "INSERT INTO dta.offer_params(
											            offer_guid, param_name, param_value)
											    VALUES ('#{@guid}', '#{pn}', '#{pv.gsub(/'/,'')}');"
			end

			@offer_features_ary.each do |f|
				@save_sql += "INSERT INTO dta.offer_features(
											            offer_guid, feature)
											    VALUES ('#{@guid}', '#{f}');"
			end

			@save_sql += "INSERT INTO dta.offer_seller(
										            offer_guid, type, name, address, link, user_id)
										    VALUES ('#{@guid}', '#{@seller_hash["seller_type"]}', '#{@seller_hash["seller_name"].gsub(/'/,'')}', '#{@seller_hash["seller_address"].gsub(/'/,'')}', '#{@seller_hash["seller_full_offer"]}', null);"

			@save_sql += "INSERT INTO dta.offer_params(
										            offer_guid, param_name, param_value)
										    VALUES ('#{@guid}', 'price_type', '#{@price_type}');"
			@save_sql += "INSERT INTO dta.offer_params(
										            offer_guid, param_name, param_value)
										    VALUES ('#{@guid}', 'price_value', '#{@price_value}');"
			@save_sql += "INSERT INTO dta.offer_params(
										            offer_guid, param_name, param_value)
										    VALUES ('#{@guid}', 'price_currency', '#{@price_currency}');"
			
		rescue StandardError => e
			@is_error += 1
			LOGGER.create_log('error', "Offer #{@guid}: no sql_save: #{e}")
		end
	end

	def prepare_update_sql(session_guid)
		begin
			@update_sql = ''
			@update_sql += "UPDATE dta.offer_links SET is_visited = 1 where offer_guid = '#{@guid}';"
			@update_sql += "UPDATE dta.offer_links SET n_errors = #{@is_error} where offer_guid = '#{@guid}';"
		rescue StandardError => e
			LOGGER.create_log('error', "Offer #{@guid}: no sql_update: #{e}")			
		end
	end

	def extract_offer_message
		begin
			offer_message = extract_data(@page, "div.offer-content__message")
			@offer_message = offer_message[0].text
		rescue StandardError => e
			@is_error += 1
			@offer_message = "Brak offer message"
			LOGGER.create_log('error', "Offer #{@guid}: no meta_items: #{e}")
		end
	end

	def set_active_flag
		extract_meta_items
		extract_offer_message

		if @offer_message.include? "nieaktualne"
		  @is_active = 0
		elsif @is_error > 0 
			@is_active = 0
		else
			@is_active = 1
		end
		update_active_flag
	end

	def update_active_flag
		sql = "update dta.offer_params_pivot 
					set is_active = #{@is_active}
					where offer_guid = '#{@guid}'"
		#puts sql
		DB_CONN.exec_sql(sql)
	end

end