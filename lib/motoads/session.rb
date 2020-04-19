class Session
	
	attr_reader :session_guid
	attr_reader :session_start_time

	def initialize
		@session_guid = SecureRandom.uuid
		@session_start_time = Time.now
		LOGGER.create_log('info', "New scrape session - id: #{@session_guid}")
	end

	def save_session_details(start_time, end_time, type)
		sql = "INSERT INTO dta.scrape_session_details(
		            session_guid, start_time, end_time, type)
		    		VALUES ($1, $2, $3, $4);"
		params_arr = [@session_guid, start_time, end_time, type]
		DB_CONN.exec_prepared(sql, params_arr)
	end

	def update_session_details
		sql = "UPDATE dta.scrape_session_details SET end_time = '#{Time.now}' where session_guid = '#{@session_guid}'"
		DB_CONN.exec_sql(sql)
	end

end
