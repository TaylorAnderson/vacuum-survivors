extends Node


var current:Array[UpgradeData] = [];
var player_pool:Array[UpgradeData] = [];
var dungeon_pool:Array[UpgradeData] = [];
var all:Array[UpgradeData] = [];
var all_player:Array[UpgradeData] = [];
var all_dungeon:Array[UpgradeData] = [];
var upgrades_path = "res://data/upgrades"
signal upgrade_acquired(upgrade:UpgradeData);
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout;
	all_player = find_upgrades(upgrades_path + "/player")
	all_dungeon = find_upgrades(upgrades_path + "/dungeon")
	
	all.append_array(all_player);
	all.append_array(all_dungeon);
	
	for upgrade in all_player:
		print(upgrade);
	
func add_upgrade(upgrade:UpgradeData):
	current.append(upgrade)
	if player_pool.has(upgrade): player_pool.erase(upgrade);
	elif dungeon_pool.has(upgrade): dungeon_pool.erase(upgrade);
	else:
		push_error("Upgrade acquired that wasn't part of either pool")
	upgrade_acquired.emit(upgrade);

func reset():
	current = [];
	player_pool = all_player.duplicate();
	dungeon_pool = all_dungeon.duplicate();
func find_upgrades(path) -> Array[UpgradeData]:
	var dir = DirAccess.open(path)
	var upgrades_found:Array[UpgradeData] = [];
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

