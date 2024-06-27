extends Node2D
@onready var player = $Player
signal player_died();

@onready var upgrade_screen = $CanvasLayer/UpgradeScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout;
	upgrade_screen.activate();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_hp_lost(new_hp):
	if new_hp == 0:
		player.visible = false;
		player_died.emit();
