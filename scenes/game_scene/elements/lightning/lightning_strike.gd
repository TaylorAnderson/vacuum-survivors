extends Node2D
class_name LightningStrike
@onready var strike = $Strike
@onready var explosion = $Explosion
@onready var hit_area:Area2D = $HitArea
@onready var joltable:Joltable = $Joltable
@export var knockback_speed:float = 700;

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout;
	var targets = hit_area.get_overlapping_bodies();
	targets.append_array(hit_area.get_overlapping_areas());
	for target in targets:
		if target is Slime:
			target.velocity += global_position.direction_to(target.global_position) * knockback_speed 
		var healthbar:Bar = Find.child_by_type(target, Bar);
		if healthbar:
			Events.damage_given.emit(Upgrades.lightning_damage, target, target.global_position)
			healthbar.add_value(-Upgrades.lightning_damage)
	strike.play("default");
	await get_tree().create_timer(0.05);
	explosion.play("default");

	

