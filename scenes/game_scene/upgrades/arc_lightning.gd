extends Upgrade
@export var joltable:Joltable;
func _on_enable():
	await  get_tree().physics_frame;
	joltable.max_iterations += data.custom_data["extra_arcs"];
	var circle_shape:CircleShape2D = joltable.collision_shape.shape
	circle_shape.radius += data.custom_data["extra_distance"];
