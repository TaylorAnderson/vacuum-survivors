extends Area2D
class_name ScoreParticle
@onready var ray_cast:RayCast2D = $RayCast2D
@export var color1:Color;
@export var color2:Color;
@export var color_swap_interval:float = 0.1;
@export var lifetime:float = 3;
var value:int = 1;
var velocity:Vector2 = Vector2.ZERO;
var flicker_counter = 0;
var color_swap_timer = 0;
@export var flicker_time:float
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	color_swap_timer += delta;
	if color_swap_timer > color_swap_interval:
		color_swap_timer = 0;
		modulate = color1 if modulate == color2 else color2;
	ray_cast.rotation = velocity.angle()
	if ray_cast.is_colliding():
		velocity = velocity * ray_cast.get_collision_normal()
	velocity *= 0.9;
	position += velocity * delta;
