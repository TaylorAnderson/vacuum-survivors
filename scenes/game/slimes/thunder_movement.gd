extends EnemyMovement
@onready var shapecast = $ShapeCast2D

var parent_original_sprite_scale;
# we're gonna  keep this basic for now
func do_movement(delta):
	super.do_movement(delta);
	do_slime_effect();
	if not parent_original_sprite_scale:
		parent_original_sprite_scale = parent.sprite.scale;
	parent.move_and_slide();
	


func _on_health_bar_value_changed(old_value, new_value):
	if not enabled: return;
	if new_value < old_value and new_value != 0:
		var tween:Tween = create_tween()
		tween.tween_property(parent, "scale", Vector2(0, parent_original_sprite_scale.y * 1.5), 0.15);
		await tween.finished;
		var tween2 = create_tween();
		tween2.tween_property(parent, "scale", parent_original_sprite_scale, 0.15);
		var ray_vec:Vector2 = Vector2(shapecast.target_position.length(), 0);
		shapecast.global_position = player.global_position
		var angle = rad_to_deg((player.global_position - parent.global_position).angle());
		for i in range(360/8):
			ray_vec = ray_vec.rotated(deg_to_rad(angle + (360/(360/8))));
			shapecast.target_position = ray_vec;
			shapecast.force_shapecast_update();
			shapecast.force_update_transform()
			if not shapecast.is_colliding():
				parent.global_position = shapecast.global_position + ray_vec;
				break;
			
