extends Upgrade
@export var joltable:Joltable;
func _on_enable():
	joltable.max_forks += data.custom_data["extra_forks"];
	Upgrades.lightning_damage *= data.custom_data["damage_multiplier"]
