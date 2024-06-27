extends Area2D
class_name Joltable;
var potential_next_nodes:Array[Joltable];
var time_since_last_pulsed:float = 0;

@onready var sprite = $Sprite2D
@onready var line = $Line2D

@export var max_iterations:int = 7;

##This is optional.  Will deal damage to it on pulse
@export var health_bar:Bar;
@export var damage:int = 1;
@export var lifetime:float = 0.25;
var life_timer:float = 0;

var cooldown = 0.5;

var target:Node2D;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	time_since_last_pulsed += delta;
	life_timer += delta;
	if life_timer > lifetime:
		life_timer = 0;
		line.visible = false;
		sprite.visible = false;
		line.points = [Vector2.ZERO]
		target = null;
	else:
		if target and is_instance_valid(target):
			line.points[1] = (target.global_position - global_position) / get_parent().scale

func pulse(iterations:int):
	$AudioStreamPlayer.play();
	potential_next_nodes = [];
	for node in get_overlapping_areas():
		add_potential_node(node);
	for node in get_overlapping_bodies():
		add_potential_node(node);
	if iterations >= max_iterations: return;
	life_timer = 0;
	
	if health_bar:
		health_bar.add_value(-damage);
	potential_next_nodes.sort_custom(func(a, b): 
		return a.time_since_last_pulsed < time_since_last_pulsed;
	);
	if potential_next_nodes.size() > 0:
		var next_node = potential_next_nodes[0];
		next_node.pulse(iterations + 1)
		target = next_node;
		# we manipulate this point in process
		line.add_point(Vector2.ZERO)
		line.visible = true;
		sprite.visible = true;
	time_since_last_pulsed = 0;


func add_potential_node(object):
	var joltable = Find.child_by_type(object, Joltable)
	if joltable and joltable != self:
		potential_next_nodes.append(joltable);
