extends Upgrade
class_name GunkGuard
@onready var sprite = $Sprite2D
@onready var area = $Area2D

var knockback_speed = 500;
var hp = 0;
var active = false;

func _on_area_2d_body_entered(body):
	if not enabled or not active: return
	if body is Slime:
		on_hit_slime(body);
		
func on_hit_slime(body:Slime):
	hp -= 1;
	if hp <= 0:
		body.velocity += get_parent().global_position.direction_to(body.global_position) * knockback_speed
		active = false;
		sprite.visible = false;
	


func _on_player_element_changed(old_element, new_element):
	if not enabled: return
	if new_element == Data.Element.SLIME:
		active = true;
		sprite.visible = true;
		hp = data.custom_data["hp"];
