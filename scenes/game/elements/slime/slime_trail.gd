extends Node2D

@export var slime_puddle_interval:float = 0.5;
@export var slime_puddle_lifetime:float = 10;
@export var slime_puddle_scene:PackedScene;
var slime_puddle_timer = 0;
@export var exceptions:Array[PhysicsBody2D]
@export var enabled:bool = false;
@export var highest_parent:Node;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not enabled: return
	slime_puddle_timer += delta;
	if slime_puddle_timer > slime_puddle_interval:
		slime_puddle_timer = 0;
		var slime_puddle = slime_puddle_scene.instantiate();
		slime_puddle.lifetime = slime_puddle_lifetime;
		slime_puddle.exceptions = exceptions;
		slime_puddle.global_position = global_position;
		highest_parent.get_parent().add_child(slime_puddle);
		slime_puddle.scale = get_parent().scale;
