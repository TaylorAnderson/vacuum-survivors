extends Panel
class_name UpgradeScreen
@export var upgrade_cards:Array[UpgradeCard]
@onready var animation_player = $AnimationPlayer
@onready var option_selected = $OptionSelected

var dungeon_evolution_interval = 5;
var times_shown:int = 0;

signal upgrade_selected(upgrade);
# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

func activate():
	if visible: return;
	animation_player.play("level_up", -1, 1.2);
	
	visible = true;
	print("pausing");
	get_tree().paused = true;
	var potential_upgrades = [];
	
	# filtering the upgrades	
	
	var upgrades_picked = [];
	
	for upgrade in Upgrades.player_pool:
		if upgrade.pre_req == null or Upgrades.current.has(upgrade.pre_req):
			potential_upgrades.append(upgrade);
	
	# assigning the upgrades to the cards
	for i in range(3):
		var assigned_upgrade = potential_upgrades.pick_random();
		potential_upgrades.erase(assigned_upgrade);
		print(assigned_upgrade.name);
		upgrade_cards[i].setup(assigned_upgrade);
		
	times_shown += 1;


func _on_upgrade_selected(card:UpgradeCard):
	option_selected.play();
	Upgrades.add_upgrade(card.upgrade)
	await card.finished_select_anim
	get_tree().paused = false;
	visible = false;
	upgrade_selected.emit(card.upgrade);




func _on_xp_bar_levelled_up(new_level):
	activate();
