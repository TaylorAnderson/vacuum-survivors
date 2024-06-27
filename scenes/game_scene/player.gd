extends CharacterBody2D
@onready var sprite:Sprite2D = $Sprite2D
@onready var vacuum_area:VacuumArea = $Sprite2D/VacuumArea
@onready var suck_in_anim:AnimatedSprite2D = $Sprite2D/SuckInAnim
@onready var vacuum_bar:Bar = $VacuumBar
@onready var shot_anim:AnimatedSprite2D = $Sprite2D/ShotAnim
@onready var element_lifetime_timer:Timer = $ElementLifetime

@export var speed:float = 500;
@export var accel = 10;
@export var friction = 30;
@export var shot_speed = 700;
@export var shot_cost = 3;
@export var fire_interval = 0.5;
@export var fire_interval_timer = 0;
@export var dust_bullet_scene:PackedScene;
var current_element:Data.Element = Data.Element.NORMAL;
var current_speed:float;
var hp:int = 3;

signal hp_lost(new_hp);
signal xp_gained(xp_gained);

var invicibility_time = 2;
var invincibility_timer = 0;
var invisible_ticker = 0;

var element_lifetime = 5;
# Called when the node enters the scene tree for the first time.
func _ready():
	current_speed = speed;
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
	
	current_speed = speed;
	if Input.is_action_pressed("suck"): 
		current_speed = speed * 0.75;
		if not $VacuumNoise.playing:
			$VacuumNoise.play();
	else:
		$VacuumNoise.stop();
	if Input.is_action_just_pressed("suck"):
		$VacuumStart.play();
	if Input.is_action_just_released("suck"):
		$VacuumEnd.play();
	if Input.is_action_just_pressed("shoot"):
		fire_interval_timer = fire_interval + 1
	if Input.is_action_pressed("shoot"):
		fire_interval_timer += delta;
		if fire_interval_timer > fire_interval and vacuum_bar.value >= shot_cost:
			$ShootNoise.play();
			fire_interval_timer = 0;
			current_speed = speed * 0.75;
			var dust_bullet = dust_bullet_scene.instantiate();
			get_parent().add_child(dust_bullet)
			var shoot_angle = Vector2.from_angle(sprite.rotation + PI/2)
			dust_bullet.shoot(self, shoot_angle * shot_speed);
			dust_bullet.global_position = global_position;
			dust_bullet.set_element(current_element);
			vacuum_bar.add_value(-shot_cost)
			shot_anim.play("shoot");
	move_and_slide()

func set_element(new_element:Data.Element):
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
