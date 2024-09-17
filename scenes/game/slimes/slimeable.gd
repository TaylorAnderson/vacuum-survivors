extends Sprite2D
class_name Slimeable;
var enabled:bool;
var lifetime_counter:float = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func trigger():
	$AudioStreamPlayer.play()
	lifetime_counter = Upgrades.slimeable_lifetime;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	enabled = lifetime_counter > 0;
	visible = enabled;
	lifetime_counter -= delta;
