module Extractor
	def extract_pages(page, code)
		case code
		when 'otomoto'
			page.css('ul.om-pager span.page')		
		end
	end

	def extract_links(page, code)
		case code
		when 'otomoto'
			page.css('a.offer-title__link')		
		end
	end

	def extract_data(page, css)
			page.css(css)		
	end
end
