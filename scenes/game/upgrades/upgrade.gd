extends Node
class_name Upgrade
@export var data:UpgradeData;

var enabled:bool = false;

@export var force_debug_enable = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	Upgrades.upgrade_acquired.connect(_on_upgrade_acquired)
	# in case we got the upgrade before this spawned
	if Upgrades.current.has(data) or force_debug_enable: 
		enabled = true;
		_on_enable();

func _on_upgrade_acquired(upgrade:UpgradeData):
	if upgrade == self.data:
		enabled = true;
		_on_enable();

func _on_enable():
	pass;
