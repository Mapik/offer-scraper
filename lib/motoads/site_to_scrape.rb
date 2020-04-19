class SiteToScrape

	attr_reader :response, :page, :code, :n_pages, :url, :params

	def initialize(url, code)
		@url = url
		@code = code
		@params = 	case code
								when 'otomoto'
									OTOMOTO_PARAMS
								end

		@response = RestClient.get(url, params: @params)
		@page = Nokogiri::HTML(@response)
	end

	def get_number_of_pages(pager)
		if pager.nil?
			n_pages = 'Pager unavavailable...'
		elsif pager.length == 0 
		  n_pages = 1
		else
			last_page = pager.length
			n_pages = pager[last_page-2].text.to_i
		end
		@n_pages = n_pages
	end

end