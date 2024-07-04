extends Area2D
class_name DustBullet
@export var damage:int = 1;
var velocity:Vector2 = Vector2.ZERO;
var current_element:Data.Element;
var instigator;
@onready var trail = $Trail

@onready var lightning_anim = $LightningAnim
@onready var fire_anim = $FireAnim
@onready var slime_anim = $SlimeAnim


var trail_queue:Array = [];
var max_length = 20;
signal object_hit(object);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	position += velocity * delta;

func shoot(instigator, shoot_vel:Vector2):
	self.instigator = instigator;
	velocity = shoot_vel;

func set_element(element:Data.Element):
	self_modulate = Data.colors[element]
	trail.modulate = Data.colors[element]
	current_element = element;
	if element == Data.Element.FIRE:
		fire_anim.visible = true;
	if element == Data.Element.SLIME:
		slime_anim.visible = true;
	if element == Data.Element.THUNDER:
		lightning_anim.visible = true;

func _on_body_entered(body):
	hit_object(body, true);

func _on_area_entered(area):
	hit_object(area, false);


func hit_object(object, kill_bullet):
	object_hit.emit(object);
	if current_element == Data.Element.FIRE:
		var flammable = Find.child_by_type(object, Flammable);
		if flammable: flammable.set_enabled(true);
	if current_element == Data.Element.THUNDER:
		var joltable:Joltable = Find.child_by_type(object, Joltable);
		if joltable: joltable.pulse(0);
	if current_element == Data.Element.SLIME:
		var slimeable:Slimeable = Find.child_by_type(object, Slimeable);
		if slimeable: slimeable.trigger();
	var health_bar = Find.child_by_type(object, Bar)
	if health_bar and health_bar.get_parent() != instigator:
		
		if health_bar.can_be_hit_by_bullet:
			health_bar.set_value(health_bar.value - damage);
			Events.damage_given.emit(damage, object, position);
		if kill_bullet: queue_free();
	if object is TileMap: queue_free();
