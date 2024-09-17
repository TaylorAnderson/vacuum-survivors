extends Camera2D

@export var target:Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		var mouse_offset = get_global_mouse_position() - target.global_position;
		position = target.global_position + mouse_offset * 0.05;
