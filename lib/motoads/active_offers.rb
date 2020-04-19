class ActiveOffers

	#attr_accessor :active_offers 

	def initialize(sql)
		@sql = sql
		get_active_offers(@sql)
	end

	def get_active_offers(sql)
		@active_offers = DB_CONN.exec_sql(sql)

		LOGGER.create_log('info', "N active offers: #{@active_offers.ntuples}") 
	end
	
	def check_if_active
		i = 0
		@active_offers.each do |op| 
			LOGGER.create_log('info', "Active offer number: #{i += 1}") 
			
			begin
				op = OfferPage.new(op["link"], op["offer_guid"], op["code"])
				osp = op.make_offer_subpage
				osp.set_active_flag
			rescue StandardError => e
				LOGGER.create_log('error', "Error with offer #{op['offer_guid']}: #{e}") 	
			end

			
		end 
	end
	
end