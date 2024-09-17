extends Upgrade
@export var player:Player
func _on_enable():
	Upgrades.fire_damage *= data.custom_data["fire_damage_multiplier"]
	player.damage *= data.custom_data["bullet_damage_debuff"];
func _on_player_element_changed(old_element, new_element):
	if not enabled: return;
	# basically -- if we're switching TO fire, apply the buff.
	# if we're switching FROM fire, remove the buff.
	if new_element == Data.Element.FIRE:
		player.fire_interval /= data.custom_data["fire_rate_multiplier"]
	if old_element == Data.Element.FIRE:
		player.fire_interval *= data.custom_data["fire_rate_multiplier"];
			
