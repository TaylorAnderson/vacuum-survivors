extends Upgrade
class_name TurboEngine
@export var player:Player
@export var flame_scene:PackedScene;
var fire_counter = 0;
	
func _process(delta):
	if not enabled: return
	if player.current_element == Data.Element.FIRE and \
	player.velocity.length() > 0 and \
	player.current_speed == player.run_speed:
		fire_counter += delta;
		if fire_counter > data.custom_data["fire_rate"]:
			fire_counter = 0;
			var new_fire:Flammable = flame_scene.instantiate();
			player.get_parent().add_child(new_fire);
			new_fire.global_position = player.global_position;
			new_fire.set_enabled(true);
		
func _on_player_element_changed(old_element, new_element):
	if not enabled: return;
	# basically -- if we're switching TO fire, apply the buff.
	# if we're switching FROM fire, remove the buff.
	if new_element == Data.Element.FIRE:
		
		player.run_speed *= data.custom_data["run_speed_multiplier"]
	elif old_element == Data.Element.FIRE:
		player.run_speed /= data.custom_data["run_speed_multiplier"];
