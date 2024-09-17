extends Node

@export var damage_number_scene:PackedScene;
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.damage_given.connect(spawn_damage_number)

func spawn_damage_number(damage, target, position):
	var damage_number = damage_number_scene.instantiate();
	add_child(damage_number);
	damage_number.global_position = position;
	damage_number.set_number(damage);
