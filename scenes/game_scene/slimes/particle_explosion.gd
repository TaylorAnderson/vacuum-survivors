extends Node2D

## We assume this has a velocity vector property.
@export var particle_scene:PackedScene
@export var amount_min:int = 5;
@export var amount_max:int = 10;
@export var velocity_min:float = 200;
@export var velocity_max:float = 300;

func trigger():
	var amount = randi_range(amount_min, amount_max)
	for i in amount:
		var new_particle = particle_scene.instantiate()
		call_deferred("add_child", new_particle);
		new_particle.velocity = Vector2(randf_range(velocity_min, velocity_max), 0);
		new_particle.velocity = new_particle.velocity.rotated(randf() * (PI*2))

