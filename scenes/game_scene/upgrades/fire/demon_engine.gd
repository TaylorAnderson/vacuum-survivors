extends TurboEngine


func _on_player_element_changed(old_element, new_element):
	if not enabled: return;
	super._on_player_element_changed(old_element, new_element)
	# basically -- if we're switching TO fire, apply the buff.
	# if we're switching FROM fire, remove the buff.
	if new_element == Data.Element.FIRE:
		print("happening");
		player.walk_speed *= data.custom_data["walk_speed_multiplier"]
	elif old_element == Data.Element.FIRE:
		player.walk_speed /= data.custom_data["walk_speed_multiplier"];

