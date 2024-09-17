extends Node


var current:Array[UpgradeData] = [];
var player_pool:Array[UpgradeData] = [];
var dungeon_pool:Array[UpgradeData] = [];
var all:Array[UpgradeData] = [];
var all_player:Array[UpgradeData] = [];
var all_shop:Array[UpgradeData] = [];
var current_cursed_upgrade:String;
var upgrades_path = "res://data/upgrades"

var lightning_damage = 0;
var fire_damage = 0;
var slimeable_lifetime = 0;

var og_slimeable_lifetime = 5;
var og_fire_damage = 5;
var og_lightning_damage = 3;
signal upgrade_acquired(upgrade:UpgradeData);
# Called when the node enters the scene tree for the first time.
func _ready():
	all_player = find_upgrades(upgrades_path + "/player")
	all_shop = find_upgrades(upgrades_path + "/shop")
	
	all.append_array(all_player);
	all.append_array(all_shop);
	
	reset();
	
func add_upgrade(upgrade:UpgradeData):
	current.append(upgrade)
	if player_pool.has(upgrade): player_pool.erase(upgrade);
	elif dungeon_pool.has(upgrade): dungeon_pool.erase(upgrade);
	upgrade_acquired.emit(upgrade);

func reset():
	fire_damage = og_fire_damage;
	lightning_damage = og_lightning_damage;
	slimeable_lifetime = og_slimeable_lifetime;
	current = [];
	player_pool = all_player.duplicate();
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
