require 'rest-client'
require 'nokogiri' 
require 'pg'
require 'logger'
require 'securerandom'
require 'json'
#require 'sequel' #kiedys moze w przyszłości...

#Modules
require_relative "motoads/extractor"
require_relative "motoads/save_data"

#Config
require_relative "../config/config_file"

#Classes
require_relative "motoads/session"
require_relative "motoads/db_connection"
require_relative "motoads/my_logger"
require_relative "motoads/site_to_scrape"
require_relative "motoads/page_with_offers"
require_relative "motoads/offer_page"
require_relative "motoads/offer_page_otomoto"
require_relative "motoads/single_param"
require_relative "motoads/offer_params"
require_relative "motoads/offers_to_transpose"
require_relative "motoads/active_offers"

include Extractor

LOGGER = MyLogger.new
DB_CONN = DbConnection.new(MP_USER, MOTOADS_DB)

def last_otomoto_id
	# sql = "select max(offer_id::bigint) max_id from dta.offer_details where offer_id != '';"
	# rs = DB_CONN.exec_sql sql
	# return rs[0]['max_id']
	return 0 #żeby ściagać za każdym razem całą baze
end