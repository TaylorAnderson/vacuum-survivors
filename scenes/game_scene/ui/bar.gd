extends Sprite2D
class_name Bar;
@export var max:int = 50;
@onready var bar:Sprite2D = $BarFG
@export var value:int = 0;
@export var can_kill_parent:bool = false;
signal value_changed(old_value, new_value);
@export var is_health_bar:bool = false;
@export var can_be_hit_by_bullet:bool = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	set_value(value);
	pass # Replace with function body.

func set_value(new_value:int):
	var old_value = value;
	value = new_value;
	if value <= 0:
		value = 0;
		if can_kill_parent:
			get_parent().queue_free();
			return;
	if value >= max: 
		if is_health_bar: visible = false;
		value = max;
	else:
		if is_health_bar: visible = true;
	value_changed.emit(old_value, value);
	bar.scale.x = float(self.value) / float(self.max);
func add_value(addition:int):
	set_value(value + addition);
