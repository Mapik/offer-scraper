class OfferPage
	
	attr_reader :url, :code, :guid

	def initialize(link, guid, code)
		@url = link
		@guid = guid
		@code = code
	end

	def make_offer_subpage
		case @code
		when 'otomoto'
			OfferPageOtomoto.new(@url, @guid)
		end
	end
end