# Keep data for the current month only  
#Logger.new("#{LOG_DIR}/this_month.log", 'monthly')  
# Keep data for today and the past 20 days.  
#Logger.new("#{LOG_DIR}/application.log", 20, 'daily')  
# Start the log over whenever the log exceeds 100 megabytes in size.  
#Logger.new("#{LOG_DIR}/application.log", 0, 100 * 1024 * 1024)  
#LOGGER = Logger.new(STDOUT)


class MyLogger
	
	def initialize
		@l = Logger.new("#{LOG_DIR}/application.log", 7, 1048576)  
		@ls = Logger.new(STDOUT)
	end
		
	def create_log(type="unknown", log_text)
		[@l, @ls].each do |l|
			case type
			when 'info'
				l.info "#{log_text}"
			when 'fatal'
				l.fatal "#{log_text}"
			when 'error'
				l.error "#{log_text}"
			when 'warn'
				l.warn "#{log_text}"
			when 'debug'
				l.debug "#{log_text}"
			else
				l.unknown "#{log_text}"
			end
		end
	end
	
end