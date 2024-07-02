extends Panel
class_name UpgradeScreen
@export var upgrade_cards:Array[UpgradeCard]
@onready var animation_player = $AnimationPlayer

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
	get_tree().paused = true;
	var potential_upgrades = Upgrades.player_pool.duplicate();
	
	# filtering the upgrades	
	
	var upgrades_picked = [];
	if times_shown > dungeon_evolution_interval:
		print("getting dungeon");
		times_shown = 0;
		potential_upgrades = Upgrades.dungeon_pool.duplicate();
	for upgrade in potential_upgrades:
		if upgrade.pre_req != null and not Upgrades.current.has(upgrade.pre_req):
			potential_upgrades.erase(upgrade);
	
	# assigning the upgrades to the cards
	for i in range(3):
		var assigned_upgrade = potential_upgrades.pick_random();
		potential_upgrades.erase(assigned_upgrade);
		upgrade_cards[i].setup(assigned_upgrade);
		
	times_shown += 1;


func _on_upgrade_selected(card:UpgradeCard):
	Upgrades.add_upgrade(card.upgrade)
	await card.finished_select_anim
	get_tree().paused = false;
	visible = false;
	upgrade_selected.emit(card.upgrade);




func _on_xp_bar_levelled_up(new_level):
	activate();
