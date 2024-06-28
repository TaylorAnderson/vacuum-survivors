extends Upgrade
@export var joltable:Joltable;
func _on_enable():
	joltable.max_forks += data.custom_data["extra_forks"];
	joltable.damage += data.custom_data["extra_damage"]
