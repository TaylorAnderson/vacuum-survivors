extends NinePatchRect
@onready var animation_player = $AnimationPlayer

var mouse_over:bool = false;

signal pressed();
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_over and Input.is_action_just_pressed("left_click"):
		animation_player.play("clicked");
		pressed.emit();

func _on_mouse_entered():
	mouse_over = true;


func _on_mouse_exited():
	mouse_over = false;
