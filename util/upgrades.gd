extends Node


var current:Array[Upgrade] = [];

var all:Array[Upgrade] = [];
var all_player:Array[Upgrade] = [];
var all_dungeon:Array[Upgrade] = [];
var upgrades_path = "res://data/upgrades"
signal upgrade_acquired(upgrade:Upgrade);
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout;
	all_player = find_upgrades(upgrades_path + "/player")
	all_dungeon = find_upgrades(upgrades_path + "/dungeon")
	
	all.append_array(all_player);
	all.append_array(all_dungeon);
	
func add_upgrade(upgrade:Upgrade):
	current.append(upgrade)
	upgrade_acquired.emit(upgrade);


func find_upgrades(path) -> Array[Upgrade]:
	var dir = DirAccess.open(path)
	var upgrades_found:Array[Upgrade] = [];
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next();
		while file_name != "":
			var file_path = path + "/" + file_name;
			if dir.current_is_dir():
				upgrades_found.append_array(find_upgrades(file_path));
			else:
				var upgrade_file = load(file_path)
				upgrades_found.append(upgrade_file)
			file_name = dir.get_next();
	return upgrades_found;

