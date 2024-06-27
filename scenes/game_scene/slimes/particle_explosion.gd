extends Node2D

## We assume this has a velocity vector property.
@export var particle_scene:PackedScene
@export var amount:int = 10;
@export var velocity_min:float = 200;
@export var velocity_max:float = 300;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func trigger():
	for i in amount:
		var new_particle = particle_scene.instantiate()
		call_deferred("add_child", new_particle);
		new_particle.velocity = Vector2(randf_range(velocity_min, velocity_max), 0);
		new_particle.velocity = new_particle.velocity.rotated(randf() * (PI*2))
		
