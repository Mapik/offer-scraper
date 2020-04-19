MOTOADS_DB = 'motoads'
MP_USER = 'mp'
DATA_DIR = '/home/mp/app_data/motoads_data/data'
Dir.mkdir(DATA_DIR) unless File.exists?(DATA_DIR)

LOG_DIR = '/home/mp/app_data/motoads_data/logs'
OTOMOTO_PARAMS = {
				#'max_id' => '6011527500',
				'min_id' => '0',
										 
				#'search[filter_enum_make]' => 'buick', #zwracaj uwagę na wielkość znaków - producenci z małych
				'page' => '1'
				}

MONTH_TBR = {
	'stycznia' => 'January',
	'lutego' => 'February',
	'marca' => 'March',
	'kwietnia' => 'April',
	'maja' => 'Mai',
	'czerwca' => 'June',
	'lipca' => 'July',
	'sierpnia' => 'August',
	'września' => 'September',
	'października' => 'October',
	'listopada' => 'November',
	'grudnia' => 'December'
}

#6 011 527 500
#2000000000
#1000000000
#100000000