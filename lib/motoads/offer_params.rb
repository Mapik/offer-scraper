class OfferParams
	
	attr_reader :offer_date, :params_set, :date_str, :offer_guid

	def initialize(guid)
		sql = "select offer_guid, param_name, param_value from dta.offer_params where offer_guid = $1"
		@offer_guid = guid
		@params_set = DB_CONN.exec_prepared(sql, [@offer_guid])

		sql = "select offer_date from dta.offer_details where offer_guid = $1"	
		date_rs = DB_CONN.exec_prepared(sql, [@offer_guid])
		@date_str = date_rs[0]['offer_date']
		@offer_date = set_offer_date(@date_str)
	end

	def set_offer_date(date_str)
		begin
			date_str = replace_month_name(date_str)
			return Time.parse(date_str).utc
		rescue StandardError => e
			LOGGER.create_log('error', "Offer #{@offer_guid}: Error with TimeParsing: #{date_str}: #{e}") 	
			return nil
		end
	end

	def replace_month_name(date_str)
		MONTH_TBR.each_pair do |month_pl, month_en|
			if date_str.include?(month_pl) 
				return month_replacer(date_str, month_pl, month_en)
			else
				return nil
			end
		end 
	end

	def month_replacer(date_str, month_pl, month_en) 
		date_str.gsub(month_pl, month_en)
	end

	def transpose
			create_hash			
			prepare_statement	
			prepare_params	
			save_params_to_db	
	end

	def save_params_to_db
		DB_CONN.exec_prepared(@prepared_statement, @statement_params)
	end

	def prepare_params
		@statement_params = [ @offer_guid,
										@offer_date,
										@transposed_params['oferta_od'] ,
										@transposed_params['kategoria'] ,
										@transposed_params['marka'] ,
										@transposed_params['model'] ,
										@transposed_params['wersja'] ,
										@transposed_params['rok_produkcji'] ,
										@transposed_params['przebieg'] ,
										@transposed_params['pojemnosc_skokowa'] ,
										@transposed_params['vin'] ,
										@transposed_params['rodzaj_paliwa'] ,
										@transposed_params['moc'] ,
										@transposed_params['skrzynia_biegow'] ,
										@transposed_params['naped'] ,
										@transposed_params['emisja_co2'] ,
										@transposed_params['filtr_czastek_stalych'] ,
										@transposed_params['typ'] ,
										@transposed_params['liczba_miejsc'] ,
										@transposed_params['liczba_drzwi'] ,
										@transposed_params['kolor'] ,
										@transposed_params['metalik'] ,
										@transposed_params['perlowy'] ,
										@transposed_params['akryl_niemetalizowany'] ,
										@transposed_params['matowy'] ,
										@transposed_params['mozliwosc_finansowania'] ,
										@transposed_params['faktura_vat'] ,
										@transposed_params['vat_marza'] ,
										@transposed_params['leasing'] ,
										@transposed_params['oplata_poczatkowa'] ,
										@transposed_params['miesieczna_rata'] ,
										@transposed_params['liczba_pozostalych_rat'] ,
										@transposed_params['wartosc_wykupu'] ,
										@transposed_params['kraj_pochodzenia'] ,
										@transposed_params['pierwsza_rejestracja'] ,
										@transposed_params['zarejestrowany_w_polsce'] ,
										@transposed_params['pierwszy_wlasciciel'] ,
										@transposed_params['bezwypadkowy'] ,
										@transposed_params['uszkodzony'] ,
										@transposed_params['serwisowany_w_aso'] ,
										@transposed_params['stan'] ,
										@transposed_params['kod_silnika'] ,
										@transposed_params['homologacja_ciezarowa'] ,
										@transposed_params['kierownica_po_prawej'] ,
										@transposed_params['tuning'] ,
										@transposed_params['price_type'] ,
										@transposed_params['price_value'] ,
										@transposed_params['price_currency'] ,
									]	
	end

	def prepare_statement
		@prepared_statement = 
		"INSERT INTO dta.offer_params_pivot(
            offer_guid, offer_date, oferta_od, kategoria, marka, model, wersja, rok_produkcji, 
            przebieg, pojemnosc_skokowa, vin, rodzaj_paliwa, moc, skrzynia_biegow, 
            naped, emisja_co2, filtr_czastek_stalych, typ, liczba_miejsc, 
            liczba_drzwi, kolor, metalik, perlowy, akryl_niemetalizowany, 
            matowy, mozliwosc_finansowania, faktura_vat, vat_marza, leasing, 
            oplata_poczatkowa, miesieczna_rata, liczba_pozostalych_rat, wartosc_wykupu, 
            kraj_pochodzenia, pierwsza_rejestracja, zarejestrowany_w_polsce, 
            pierwszy_wlasciciel, bezwypadkowy, uszkodzony, serwisowany_w_aso, 
            stan, kod_silnika, homologacja_ciezarowa, kierownica_po_prawej, 
            tuning, price_type, price_value, price_currency, is_active)
    VALUES ($1,
						$2,
						$3,
						$4,
						$5,
						$6,
						$7,
						$8,
						$9,
						$10,
						$11,
						$12,
						$13,
						$14,
						$15,
						$16,
						$17,
						$18,
						$19,
						$20,
						$21,
						$22,
						$23,
						$24,
						$25,
						$26,
						$27,
						$28,
						$29,
						$30,
						$31,
						$32,
						$33,
						$34,
						$35,
						$36,
						$37,
						$38,
						$39,
						$40,
						$41,
						$42,
						$43,
						$44,
						$45,
						$46,
						$47,
						$48,
						1
						)"
	end

	def create_hash
		@transposed_params = {}
		@params_set.each do |p|
			sp = SingleParam.new(p["param_name"], p["param_value"])
			sp.format_param
			@transposed_params[sp.name] = sp.value
		end
	end


	def prepare_columns
		@columns_arr = ["offer_guid"]
		@transposed_params.each { |e| @columns_arr << e[0] }
	end

	def prepare_values
		@values_arr = [@offer_guid]
		@transposed_params.each { |e| @values_arr << e[1] }		
	end
end
