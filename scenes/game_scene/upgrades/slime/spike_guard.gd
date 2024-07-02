extends GunkGuard
@onready var animation_player = $AnimationPlayer
@export var gunk_guard:GunkGuard;
var cooldown = 0;
func _on_enable():
	# we want this to override the gunk guard
	gunk_guard.enabled = false;
	
func _process(delta):
	if enabled:
		cooldown -= delta;

func on_hit_slime(slime:Slime):
	if cooldown > 0: return;
	cooldown = 0.2;
	var healthbar = Find.child_by_type(slime, Bar);
	slime.velocity += get_parent().global_position.direction_to(slime.global_position) * 500
	if healthbar:
		healthbar.add_value(-data.custom_data["damage"])
		animation_player.play("pop");
		Events.damage_given.emit(data.custom_data["damage"], slime, slime.global_position);
	super.on_hit_slime(slime);
