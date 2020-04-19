require_relative '../lib/motoads.rb'

LOGGER.create_log('info', "Start new session...")
transpose_session = Session.new()

LOGGER.create_log('info', "Save session details...")
transpose_session.save_session_details(Time.now, nil, 'transpose')

LOGGER.create_log('info', "Start transposition...")

OffersToTranspose.new.transpose_offers_params

LOGGER.create_log('info', "End transposition...")

transpose_session.update_session_details
LOGGER.create_log('info', "End of session: #{transpose_session.session_guid}")