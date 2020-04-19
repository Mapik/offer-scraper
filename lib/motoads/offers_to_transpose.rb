class OffersToTranspose
	def initialize
		#sql = 'select offer_guid from dta.offer_links where is_visited = 2 limit 2;'
		sql = 	"select od.offer_guid from dta.offer_details od
						left join dta.offer_params_pivot opp
						on opp.offer_guid = od.offer_guid
						where opp.offer_guid is null and od.offer_date != ''
						"
		@guids = DB_CONN.exec_sql(sql)

		LOGGER.create_log('info', "N offers to transpose: #{@guids.ntuples}") 
	end

	def transpose_offers_params
		i = 0
		@guids.each do |op| 
			LOGGER.create_log('info', "Transposed offer number: #{i += 1}") 
			
			begin
				OfferParams.new(op["offer_guid"]).transpose	
			rescue StandardError => e
				LOGGER.create_log('error', "Error with offer #{op['offer_guid']}: #{e}") 	
			end

			
		end 
	end

end