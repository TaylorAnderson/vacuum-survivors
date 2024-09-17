extends Upgrade
class_name ElectricalDischarge;
@export var player:Player;
@onready var sprite = $AnimatedSprite2D
@onready var hit_area = $Area2D
@export var knockback_speed = 500;

func _on_enable():
	player.shot_bullet.connect(on_player_shot_bullet);

		
func on_player_shot_bullet():
	if player.current_element != Data.Element.THUNDER: return;
	sprite.stop();
	sprite.frame = 0;
	sprite.play("default");
	var targets = hit_area.get_overlapping_bodies();
	targets.append_array(hit_area.get_overlapping_areas());
	for target in targets:
		if target is Slime:
			target.velocity += player.global_position.direction_to(target.global_position) * knockback_speed 
		var healthbar:Bar = Find.child_by_type(target, Bar);
		if healthbar:
			Events.damage_given.emit(Upgrades.lightning_damage, target, target.global_position)
			healthbar.add_value(-Upgrades.lightning_damage)
	
