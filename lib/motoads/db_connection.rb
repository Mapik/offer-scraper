class DbConnection

	def initialize(user, db_name)
		begin
			@conn = PG.connect :dbname => "#{db_name}", :user => "#{user}"
			LOGGER.create_log('info', "Succesfully connected to db...")
		rescue StandardError => e
			LOGGER.create_log('error', "DB Error: #{e}")
		end
	end

	def exec_sql(sql_string)
		begin
			return @conn.exec sql_string
			LOGGER.create_log('info', "Succesfully executed sql...")
		rescue StandardError => e
			LOGGER.create_log('error', "DB Error: #{e}")
		end
	end

	def exec_prepared(stm, param_array)
		begin
			return @conn.exec_params(stm, param_array)
			LOGGER.create_log('info', "Succesfully executed sql...")
		rescue StandardError => e
			LOGGER.create_log('error', "DB Error: #{e}")
		end
	end


end

