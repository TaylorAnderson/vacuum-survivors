extends Label

@export var flicker_interval:float = 0.25;
var flicker_timer = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	flicker_timer += delta;
	if flicker_timer > flicker_interval:
		visible = !visible;
		flicker_timer = 0;
