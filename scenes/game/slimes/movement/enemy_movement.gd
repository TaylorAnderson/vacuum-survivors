extends Node2D
class_name EnemyMovement
var velocity:Vector2;
var player:Player;
@export var slimeable:Slimeable;
@export var parent:CollisionObject2D

var enabled:bool = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(player):
	enabled = true;
	self.player = player;
func stop():
	enabled = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if enabled:
		do_movement(delta);

	
func do_movement(delta):
	var direction = parent.global_position.direction_to(player.global_position)
	parent.sprite.rotation = direction.angle() - PI/2;
	parent.velocity += direction * parent.speed * delta;
	parent.velocity *= 0.8;

func do_slime_effect():
	if slimeable.enabled:
		parent.velocity *= 0.5;
