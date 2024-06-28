extends Upgrade

@export var player:Player
@export var flame_scene:PackedScene;
var fire_counter = 0;
func _on_enable():
	print("enabling");
	player.run_speed *= data.custom_data["run_speed_multiplier"];
	
func _process(delta):
	if not enabled: return
	
	if player.velocity.length() > 0 and player.current_speed == player.run_speed:
		fire_counter += delta;
		if fire_counter > data.custom_data["fire_rate"]:
			fire_counter = 0;
			print("spawning fire");
			var new_fire:Flammable = flame_scene.instantiate();
			player.get_parent().add_child(new_fire);
			new_fire.global_position = player.global_position;
			new_fire.set_enabled(true);
		
