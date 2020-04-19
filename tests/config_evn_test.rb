MOTOADS_DB = 'motoads'
MP_USER = 'mp'
DATA_DIR = '/mnt/dane/app_data/motoads_data/data'
Dir.mkdir(DATA_DIR) unless File.exists?(DATA_DIR)

LOG_DIR = '/mnt/dane/app_data/motoads_data/logs/test'
Dir.mkdir(LOG_DIR) unless File.exists?(LOG_DIR)

OTOMOTO_PARAMS = {
				#'max_id' => '6011527500',
				'min_id' => '6011552705',
				#'search[filter_enum_make]' => 'buick', #zwracaj uwagę na wielkość znaków - producenci z małych
				'page' => '1'
				}


#6 011 527 500
#2000000000
#1000000000
#100000000