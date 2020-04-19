class SingleParam

	attr_reader :name, :value

	def initialize(name, value)
		@name = name
		@value = value
	end
	
	def format_param
		@name = proper_col_name	
		@value = proper_val
		#return @name, @value
	end

	def proper_val
		case @name
		when 'przebieg' 
			@value.gsub(' ','').gsub('km', '').to_i
		when 'pojemnosc_skokowa' 
			@value.gsub(' ','').gsub('cm3', '').to_i
		when 'moc' 
			@value.gsub(' ','').gsub('KM', '').to_i
		when 'emisja_co2' 
			@value.gsub(' ','').gsub('g/km', '').to_i
		when 'oplata_poczatkowa' 
			@value.gsub(' ','').gsub('PLN', '').to_f
		when 'miesieczna_rata' 
			@value.gsub(' ','').gsub('PLN', '').to_f
		when 'wartosc_wykupu' 
			@value.gsub(' ','').gsub('PLN', '').to_f
		when 'price_value' 
			@value.gsub(/[a-zA-Z]/,'').to_i
		when 'offer_date'
		else
			@value
		end
	end

	def proper_col_name
		case @name
		when 'Oferta od' then 'oferta_od'
		when 'Model' then 'model'
		when 'Stan' then 'stan'
		when 'Kategoria' then 'kategoria'
		when 'Marka' then 'marka'
		when 'Rodzaj paliwa' then 'rodzaj_paliwa'
		when 'Rok produkcji' then 'rok_produkcji'
		when 'Kolor' then 'kolor'
		when 'Typ' then 'typ'
		when 'Przebieg' then 'przebieg'
		when 'Pojemność skokowa' then 'pojemnosc_skokowa'
		when 'Skrzynia biegów' then 'skrzynia_biegow'
		when 'Moc' then 'moc'
		when 'Liczba drzwi' then 'liczba_drzwi'
		when 'Liczba miejsc' then 'liczba_miejsc'
		when 'Napęd' then 'naped'
		when 'Wersja' then 'wersja'
		when 'Metalik' then 'metalik'
		when 'Kraj pochodzenia' then 'kraj_pochodzenia'
		when 'Bezwypadkowy' then 'bezwypadkowy'
		when 'Zarejestrowany w Polsce' then 'zarejestrowany_w_polsce'
		when 'Serwisowany w ASO' then 'serwisowany_w_Aso'
		when 'Pierwszy właściciel' then 'pierwszy_wlasciciel'
		when 'Pierwsza rejestracja' then 'pierwsza_rejestracja'
		when 'VAT marża' then 'vat_marza'
		when 'Możliwość finansowania' then 'mozliwosc_finansowania'
		when 'VIN' then 'vin'
		when 'Faktura VAT' then 'faktura_VAt'
		when 'Perłowy' then 'perlowy'
		when 'Kod Silnika' then 'kod_silnika'
		when 'Leasing' then 'leasing'
		when 'Filtr cząstek stałych' then 'filtr_czastek_stalych'
		when 'Uszkodzony' then 'uszkodzony'
		when 'Akryl (niemetalizowany)' then 'akryl_niemetalizowany'
		when 'Emisja CO2' then 'emisja_Co2'
		when 'Homologacja ciężarowa' then 'homologacja_ciezarowa'
		when 'Kierownica po prawej (Anglik)' then 'kierownica_po_prawej'
		when 'Tuning' then 'tuning'
		when 'Miesięczna rata' then 'miesieczna_rata'
		when 'Matowy' then 'matowy'
		when 'Liczba pozostałych rat' then 'liczba_pozostalych_rat'
		when 'Wartość wykupu' then 'wartosc_wykupu'
		when 'Opłata początkowa' then 'oplata_poczatkowa'
		else @name
		end
	end
end
