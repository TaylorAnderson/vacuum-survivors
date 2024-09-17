extends CanvasLayer
var can_exit_screen:bool = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_button_pressed():
	Events.change_scene.emit(MainScene.State.GAME);
