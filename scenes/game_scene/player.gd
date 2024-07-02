extends CharacterBody2D
class_name Player

@onready var sprite:Sprite2D = $Sprite2D
@onready var vacuum_area:VacuumArea = $Sprite2D/VacuumArea
@onready var suck_in_anim:AnimatedSprite2D = $Sprite2D/SuckInAnim
@onready var vacuum_bar:Bar = $VacuumBar
@onready var shot_anim:AnimatedSprite2D = $Sprite2D/ShotAnim
@onready var element_lifetime_timer:Timer = $ElementLifetime

# sounds
@onready var vacuum_noise = $Sounds/VacuumNoise
@onready var vacuum_start_noise = $Sounds/VacuumStart
@onready var vacuum_end_noise = $Sounds/VacuumEnd
@onready var shoot_noise = $Sounds/ShootNoise


@export var run_speed:float = 60;
@export var walk_speed:float = 45;
@export var accel = 10;
@export var friction = 30;
@export var shot_speed = 700;
@export var shot_cost = 3;
@export var fire_interval = 0.5;
@export var fire_interval_timer = 0;
@export var dust_bullet_scene:PackedScene;

var last_fired_bullet:DustBullet;
var current_element:Data.Element = Data.Element.NORMAL;
var current_speed:float;
var hp:int = 3;
var shot_queued = false;

signal hp_lost(new_hp);
signal xp_gained(xp_gained);
signal element_changed(old_element, new_element)

var invicibility_time = 2;
var invincibility_timer = 0;
var invisible_ticker = 0;

@export var element_lifetime = 10;
# Called when the node enters the scene tree for the first time.
func _ready():
	current_speed = run_speed;
	set_element(current_element)
	await get_tree().create_timer(0.01).timeout;

func _process(delta):
	if invincibility_timer > 0:
		invincibility_timer -= delta;
		invisible_ticker += delta;
		if invisible_ticker > 0.075:
			sprite.visible = not sprite.visible;
			invisible_ticker = 0;
	else:
		sprite.visible = true;
			
	vacuum_bar.rotation = -rotation
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = velocity.move_toward(direction * current_speed, accel);
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction);
	sprite.rotation = (get_global_mouse_position() - global_position).angle() - PI/2
	
	vacuum_area.enabled = Input.is_action_pressed("suck")
	suck_in_anim.visible = Input.is_action_pressed("suck")
	
	current_speed = run_speed;
	if Input.is_action_pressed("suck"): 
		current_speed = walk_speed;
		if not vacuum_noise.playing:
			vacuum_noise.play();
	else:
		vacuum_noise.stop();
	if Input.is_action_just_pressed("suck"):
		vacuum_start_noise.play();
	if Input.is_action_just_released("suck"):
		vacuum_end_noise.play();
	
	
	if Input.is_action_just_pressed("shoot"):
		shot_queued = true;
	fire_interval_timer += delta;
	
	if Input.is_action_pressed("shoot"):
		current_speed = walk_speed;
	
	if fire_interval_timer > fire_interval and vacuum_bar.value >= shot_cost:
		if Input.is_action_pressed("shoot") or shot_queued:
			shot_queued = false;
			shoot_bullet();
	move_and_slide()


func shoot_bullet():
	shoot_noise.play();
	fire_interval_timer = 0;
	
	var dust_bullet = dust_bullet_scene.instantiate();
	last_fired_bullet = dust_bullet;
	get_parent().add_child(dust_bullet)
	var shoot_angle = Vector2.from_angle(sprite.rotation + PI/2)
	dust_bullet.shoot(self, shoot_angle * shot_speed);
	dust_bullet.global_position = global_position;
	dust_bullet.set_element(current_element);
	vacuum_bar.add_value(-shot_cost)
	shot_anim.visible = true;
	shot_anim.play("shoot");
	await shot_anim.animation_finished
	shot_anim.visible = false;

func set_element(new_element:Data.Element):
	element_changed.emit(current_element, new_element);
	element_lifetime_timer.start(element_lifetime)
	current_element = new_element;
	vacuum_bar.modulate = Data.colors[new_element]
	if new_element == Data.Element.NORMAL:
		vacuum_bar.modulate = Color("#5e606e");


func _on_vacuum_area_vacuumed_object(object):
	var elemental = Find.child_by_type(object, Element)
	# now, we know this exists, so we don't need to check it
	var vacuumable:Vacuumable = Find.child_by_type(object, Vacuumable);
	vacuum_bar.add_value(vacuumable.value)
	if elemental:
		set_element(elemental.element_type);
	
	if object is ScoreParticle:
		xp_gained.emit(object.value);

func _on_hitbox_body_entered(body):
	if body is Slime and invincibility_timer <= 0:
		invincibility_timer = invicibility_time;
		velocity += body.global_position.direction_to(global_position) * 150;
		hp -= 1;
		hp_lost.emit(hp);
		if hp > 0:
			modulate = Color.RED;
			await get_tree().create_timer(0.25).timeout;
			modulate = Color.WHITE;
		else:
			visible = false;


func _on_element_lifetime_timeout():
	set_element(Data.Element.NORMAL);
