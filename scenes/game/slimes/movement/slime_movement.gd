extends EnemyMovement
@onready var slime_trail = $SlimeTrail

# we're gonna  keep this basic for now
func do_movement(delta):
	super.do_movement(delta);
	do_slime_effect();
	parent.move_and_slide();
func _process(delta):
	slime_trail.enabled = self.enabled;
