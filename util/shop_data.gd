extends Node

var upgrade_stacks:Dictionary = {};

# upgrade ids.
var element_extractor = "element_extractor"
var flared_nozzle = "flared_nozzle"
var io_tube = "io_tube"
var powered_wheels = "powered_wheels"
var stagger_engine = "stagger_engine"

func _ready():
	for data in Upgrades.all_shop:
		upgrade_stacks[data.id] = 0;
