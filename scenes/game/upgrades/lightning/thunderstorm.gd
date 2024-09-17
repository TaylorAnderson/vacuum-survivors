extends ElectricalDischarge

@export var lightning_strike_scene:PackedScene

func on_player_shot_bullet():
	if player.current_element != Data.Element.THUNDER: return;
	super.on_player_shot_bullet();
	var strike = lightning_strike_scene.instantiate() as LightningStrike;
	var offset_vec = Vector2.LEFT * 64;
	offset_vec = offset_vec.rotated(randf() * (PI * 2));
	strike.global_position = player.global_position + offset_vec;
	player.get_parent().add_child(strike);
