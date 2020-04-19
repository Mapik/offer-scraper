module SaveData
	
	def save_offer_html
		File.open("#{DATA_DIR}/html/#{@guid}.html", 'w') { |file| file.write(@page) } #dodaj warunek, że o ile plik nie istanieje
	end

	def save_picture
		begin
			File.open("#{DATA_DIR}/picture/#{@guid}.jpg", "w") do |f|
			  f.write(RestClient.get(@pict_url))
			end
		rescue StandardError => e
			LOGGER.create_log('error', "Offer #{@guid}: #{e}")
		end
		
	end

	def save_offer_json

		# offer_hash = {
		# 	guid:  @guid,
		# 	url:  @url,
		# 	scrape_time:  @scrape_time,
		#   offer_id:  @offer_id,
		#   offer_date:  @offer_date,
		#   offer_params:  @offer_params_hash,
		#   offer_features:  @offer_features_ary,
		#   seller:  @seller_hash
		# }

		# offer_hash = {
		# 	:guid => @guid,
		# 	:url => @url,
		# 	:scrape_time => @scrape_time,
		#   :offer_id => @offer_id,
		#   :offer_date => @offer_date,
		#   :offer_params => @offer_params_hash,
		#   :offer_features => @offer_features_ary,
		#   :seller => @seller_hash
		# }

		offer_hash = {
			"guid" => @guid,
			"url" => @url,
			"scrape_time" => @scrape_time,
		  "offer_id" => @offer_id,
		  "offer_date" => @offer_date,
		  "offer_params" => @offer_params_hash,
		  "offer_features" => @offer_features_ary,
		  "seller" => @seller_hash
		}

		File.open("#{DATA_DIR}/json/#{guid}.json","w") do |f|
		  f.write(offer_hash.to_json)
		  #f.write(JSON.pretty_generate(offer_hash)) #nietestewane, ale chyba generuje ładniejsze JSONy - o ile w ogole ma to znaczenie...
		end

	end
end