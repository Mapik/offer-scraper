class PageWithOffers
	
	attr_reader :response, :page, :code, :url, :params

	def initialize(url, code, page_num)
		@url = url
		@code = code
		@params = 	case code
								when 'otomoto'
									OTOMOTO_PARAMS
								end

		@params["page"] = page_num
		@response = RestClient.get(url, params: @params)
		@page = Nokogiri::HTML(@response)
	end
end