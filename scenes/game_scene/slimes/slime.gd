extends CharacterBody2D
class_name Slime;
@export var player:Node2D
@export var speed:float
@onready var element:Element = $Element
@onready var particle_explosion = $ParticleExplosion
@onready var vacuumable = $Vacuumable
@onready var slimeable = $Slimeable
@onready var slime_hit_sound = $SlimeHitSound
@onready var slime_stun_sound = $SlimeStunSound
@onready var slime_death_sound = $SlimeDeathSound
@onready var can_be_vacuumed_anim = $CanBeVacuumedAnim



@onready var death_anim:AnimatedSprite2D = $DeathAnim

@export var stunned_vacuum_resistance:float = 200;
@onready var health_bar:Bar = $Bar
@onready var sprite = $Sprite2D
@export var stun_time = 5;
var stun_timer = 0;
var stunned = false;

func _ready():
	var rand = randf();
	if rand < 0.5: element.element_type = Data.Element.SLIME;
	elif rand < 0.75: element.element_type = Data.Element.FIRE;
	elif rand < 1: element.element_type = Data.Element.THUNDER;
	set_element(element.element_type)
	health_bar.value_changed.connect(_on_health_bar_value_changed)

func set_element(element:Data.Element):
	sprite.modulate = Data.colors[element]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not player: return;
	if stunned: 
		stun_timer += delta;
		if stun_timer > stun_time and not vacuumable.being_pulled:
			sprite.modulate = Data.colors[element.element_type]
			health_bar.set_value(health_bar.max);
			stun_timer = 0;
			stunned = false;
			$StunAnim.visible = false;
			$Vacuumable.resistance = 1000;
			$Vacuumable.can_be_eaten = false;
			set_collision_layer_value(2, true);
			set_collision_layer_value(3, false);
			sprite.play("default")
		return;
	var direction = global_position.direction_to(player.global_position)
	sprite.rotation = direction.angle() - PI/2;
	velocity += direction * speed * delta;
	velocity *= 0.8;
	if slimeable.enabled:
		velocity *= 0.5;
	move_and_slide();
func _on_health_bar_value_changed(old_value, new_value):
	if new_value < old_value:
		$SlimeHitSound.play();
	if new_value == 0:
		if not stunned:
			can_be_vacuumed_anim.play("pop_in");
			slime_stun_sound.play();
			stunned = true;
			sprite.modulate = sprite.modulate.darkened(0.5);
			# 2 is entities, 3 is disabled
			set_collision_layer_value(2, false);
			set_collision_layer_value(3, true);
			$StunPoofAnim.play("poof");
			$StunAnim.visible = true;
			sprite.stop();
			$Vacuumable.resistance = stunned_vacuum_resistance;
			$Vacuumable.can_be_eaten = true;
		else:
			can_be_vacuumed_anim.play("RESET")
			slime_death_sound.play();
			stunned = true;
			death_anim.frame = 0;
			death_anim.play("default");
			death_anim.global_position = global_position;
			remove_child(particle_explosion);
			get_parent().add_child(particle_explosion);
			particle_explosion.global_position = global_position;
			particle_explosion.trigger();
			$Vacuumable.resistance = 1000;
			$Vacuumable.can_be_eaten = false;
			sprite.visible = false;
			$StunAnim.visible = false;
			$Bar.visible = false;
			$Slimeable.visible = false;
			remove_child($CollisionShape2D)
			await death_anim.animation_finished;
			queue_free();
func set_health_multiplier(health_multiplier):
	health_bar.max *= health_multiplier;
	health_bar.set_value(health_bar.max);
