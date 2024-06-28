extends Node

var upgrade:UpgradeData;

var enabled:bool = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	Upgrades.upgrade_acquired.connect(_on_upgrade_acquired)

func _on_upgrade_acquired(upgrade:UpgradeData):
	if upgrade == self.upgrade:
		_on_enable();

func _on_enable():
	pass;

