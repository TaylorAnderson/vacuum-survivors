extends CanvasLayer
@onready var animation_player = $AnimationPlayer

var can_exit_screen:bool = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_enter():
	await get_tree().create_timer(1).timeout;
	animation_player.play("intro");
	await animation_player.animation_finished
	can_exit_screen = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_can_exit_screen():
	can_exit_screen = true;
