extends Area2D
class_name Dust;
@onready var ray_cast = $RayCast2D

var velocity:Vector2 = Vector2.ZERO;
var disappearance_chance = 0.3;
# Called when the node enters the scene tree for the first time.
func _ready():
	if randf() < disappearance_chance: queue_free();
	modulate = Data.colors[Data.Element.NORMAL]
	var random_offset = Vector2.LEFT.rotated(randf_range(0, PI * 2)) * randf_range(0, 3);
	global_position += random_offset;
