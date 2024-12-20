extends Area2D
class_name Flammable;

var tick_time = 0.3;
var lifetime_ticks = 10;
var lifetime_tick_counter = 10;
var tick_timer:float; 
var enabled:bool = false;

var nodes_in_range:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false;

func set_enabled(enabled):
	if enabled:
		$AudioStreamPlayer.play();
	self.enabled = enabled;
	self.visible = enabled;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:

		tick_timer += delta;
		
		if tick_timer > tick_time:
			nodes_in_range = [];
			for node in get_overlapping_areas():
				add_potential_node(node);
			for node in get_overlapping_bodies():
				add_potential_node(node);
			for health_bar in nodes_in_range:
				Events.damage_given.emit(Upgrades.fire_damage , health_bar.get_parent(), global_position)
				health_bar.add_value(-Upgrades.fire_damage);
			tick_timer = 0;
			lifetime_tick_counter -= 1;
			if lifetime_tick_counter <= 0:
				set_enabled(false);
				lifetime_tick_counter = lifetime_ticks;
				return;

func add_potential_node(object):
	var health_bar:Bar = Find.child_by_type(object, Bar)
	if health_bar and health_bar.is_health_bar:
		nodes_in_range.append(health_bar);
