extends Panel
class_name UpgradeScreen
@export var upgrade_cards:Array[UpgradeCard]

var dungeon_evolution_interval = 5;
var times_shown:int = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

func activate():
	visible = true;
	get_tree().paused = true;
	var potential_upgrades = Upgrades.all_player;
	
	# filtering the upgrades
	
	var upgrades_picked = [];
	if times_shown > dungeon_evolution_interval:
		times_shown = 0;
		potential_upgrades = Upgrades.all_dungeon;
	for upgrade in potential_upgrades:
		if upgrade.pre_req != null and not Upgrades.current.has(upgrade.pre_req):
			potential_upgrades.erase(upgrade);
	
	# assigning the upgrades to the cards
	
	for i in range(3):
		var assigned_upgrade = potential_upgrades.pick_random();
		print(assigned_upgrade);
		potential_upgrades.erase(assigned_upgrade);
		upgrade_cards[i].setup(assigned_upgrade);
		
	times_shown += 1;


func _on_upgrade_selected(card:UpgradeCard):
	print("HELLO");
	Upgrades.add_upgrade(card.upgrade)
	await card.finished_select_anim
	get_tree().paused = false;
	visible = false;

