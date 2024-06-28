extends Node

@export var upgrades_to_preload:Array[UpgradeData]
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.3).timeout;
	for data in upgrades_to_preload:
		Upgrades.add_upgrade(data);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
