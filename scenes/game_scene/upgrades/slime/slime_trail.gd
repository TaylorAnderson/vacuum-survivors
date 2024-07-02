extends Upgrade

@onready var slime_trail = $SlimeTrail

func _on_player_element_changed(old_element, new_element):
	if not enabled: return;
	if new_element == Data.Element.SLIME:
		slime_trail.enabled = true;
	else:
		slime_trail.enabled = false;
