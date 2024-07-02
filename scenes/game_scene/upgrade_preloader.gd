extends Node

@export var upgrades_to_preload:Array[UpgradeData]
var added_upgrades = false;
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not added_upgrades:
		added_upgrades = true;
		for data in upgrades_to_preload:
			Upgrades.add_upgrade(data);
