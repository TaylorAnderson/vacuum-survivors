extends Area2D
@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer

@export var sound_a:AudioStream
@export var sound_b:AudioStream;
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout;
	audio_stream_player.stream = [sound_a, sound_b].pick_random();
	audio_stream_player.play()
	var targets = get_overlapping_bodies();
	targets.append_array(get_overlapping_areas());
	for target in targets: 
		var healthbar:Bar = Find.child_by_type(target, Bar);
		if healthbar:
			Events.damage_given.emit(Upgrades.fire_damage * 2, target, target.global_position)
			healthbar.add_value(-Upgrades.fire_damage * 2)
	
