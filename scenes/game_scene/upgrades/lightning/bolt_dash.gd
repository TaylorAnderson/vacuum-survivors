extends Upgrade
class_name BoltDash;
@export var player:Player;

@onready var start_jolt:Joltable = $StartJolt
@onready var end_jolt:Joltable = $EndJolt

func _process(delta):
	if enabled:
		if Input.is_action_just_pressed("suck"):
			if is_instance_valid(player.last_fired_bullet) and \
			player.last_fired_bullet.current_element == Data.Element.THUNDER:
				do_dash()
func do_dash():
	player.last_fired_bullet.queue_free();
	start_jolt.global_position = player.global_position;
	player.global_position = player.last_fired_bullet.global_position;
	end_jolt.global_position = player.last_fired_bullet.global_position;
	start_jolt.can_pulse = true;
	end_jolt.can_pulse = true;
	print("hello???");
	start_jolt.pulse_to(1000, end_jolt);
	
