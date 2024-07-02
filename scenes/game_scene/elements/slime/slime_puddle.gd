extends Area2D
@onready var sprite = $AnimatedSprite2D
var exceptions:Array[PhysicsBody2D]
@export var lifetime = 10;
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.stop();
	sprite.frame = randi_range(0, 3);

func _process(delta):
	lifetime -= delta;
	if lifetime < 1:
		scale = Vector2.ONE * lifetime;
	if lifetime < 0:
		queue_free();
	for body in get_overlapping_bodies():
		if "velocity" in body and not body in exceptions:
			body.velocity *= 0.5;
