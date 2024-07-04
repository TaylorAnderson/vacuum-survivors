extends Node2D
@onready var player = $Player
signal player_died();


@onready var upgrade_screen = $CanvasLayer/UpgradeScreen



func _process(delta):
	pass

func _on_player_hp_lost(new_hp):
	if new_hp == 0:
		player.visible = false;
		player_died.emit();
