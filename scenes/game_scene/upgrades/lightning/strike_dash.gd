extends BoltDash

@export var lightning_strike_scene:PackedScene


func do_dash():
	super.do_dash();
	var strike = lightning_strike_scene.instantiate();
	player.get_parent().add_child(strike);
	strike.global_position = player.global_position;
