class_name NameGen


const FIRST_NAME_LIST: Array[String] = [
	"Bella",
	"Daisy",
	"Leo",
	"Luna",
	"Max",
	"Oliver",
]

const LAST_NAME_PREFIX_LIST: Array[String] = [
	"Cuddle",
	"Cutey",
	"Fluffy",
	"Grumpy",
	"Kitty",
	"McCat",
	"Silly",
	"Snicker",
	"Snuggle",
	"Tuna",
]

const LAST_NAME_SUFFIX_LIST: Array[String] = [
	"belly",
	"boots",
	"buns",
	"face",
	"paws",
	"puff",
	"tail",
]

const FULL_NAME_PATTERN := "{first} {last_prefix}{last_suffix}"


static func random() -> String:
	return FULL_NAME_PATTERN.format({
		"first": FIRST_NAME_LIST.pick_random(),
		"last_prefix": LAST_NAME_PREFIX_LIST.pick_random(),
		"last_suffix": LAST_NAME_SUFFIX_LIST.pick_random(),
	})
