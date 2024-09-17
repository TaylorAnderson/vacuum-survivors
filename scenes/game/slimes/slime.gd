extends CharacterBody2D
class_name Slime;
@export var player:Node2D
@export var speed:float
@onready var element:Element = $Element
@onready var particle_explosion = $FX/ParticleExplosion
@onready var vacuumable = $Vacuumable
@onready var slimeable = $Slimeable
@onready var slime_hit_sound = $Sounds/SlimeHitSound
@onready var slime_stun_sound = $Sounds/SlimeStunSound
@onready var slime_death_sound = $Sounds/SlimeDeathSound
@onready var can_be_vacuumed_anim = $CanBeVacuumedAnim
@onready var slime_movement = $Behaviours/SlimeMovement
@onready var fire_movement = $Behaviours/FireMovement
@onready var thunder_movement = $Behaviours/ThunderMovement

var movement:EnemyMovement;

@onready var stun_anim = $FX/StunAnim



@onready var death_anim:AnimatedSprite2D = $FX/DeathAnim

@export var stunned_vacuum_resistance:float = 200;
@onready var health_bar:Bar = $HealthBar
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
	match element:
		Data.Element.FIRE:
			movement = fire_movement
		Data.Element.THUNDER:
			movement = thunder_movement;
		Data.Element.SLIME:
			movement = slime_movement;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not player: return;
	if stunned: 
		movement.stop();
		stun_timer += delta;
		if stun_timer > stun_time and not vacuumable.being_pulled:
			sprite.modulate = Data.colors[element.element_type]
			health_bar.set_value(health_bar.max);
			stun_timer = 0;
			stunned = false;
			stun_anim.visible = false;
			$Vacuumable.resistance = 1000;
			$Vacuumable.can_be_eaten = false;
			set_collision_layer_value(2, true);
			set_collision_layer_value(3, false);
			sprite.play("default")
		return;
	else:
		if not movement.enabled:
			movement.start(player);
func _on_health_bar_value_changed(old_value, new_value):
	if new_value < old_value:
		$Sounds/SlimeHitSound.play();
	if new_value == 0:
		if not stunned:
			print("stunned");
			#can_be_vacuumed_anim.play("pop_in");
			slime_stun_sound.play();
			stunned = true;
			sprite.modulate = sprite.modulate.darkened(0.5);
			# 2 is entities, 3 is disabled
			set_collision_layer_value(2, false);
			set_collision_layer_value(3, true);
			$FX/StunPoofAnim.play("poof");
			stun_anim.visible = true;
			sprite.stop();
			$Vacuumable.resistance = stunned_vacuum_resistance;
			$Vacuumable.can_be_eaten = true;
		else:
			# we might get to this point when we're already queued to die
			if not visible: return;
			Events.monster_killed.emit(self);
			slime_death_sound.play();
			
			visible = false;
			stunned = true;
			movement.stop();
			death_anim.get_parent().remove_child(death_anim);
			get_parent().add_child(death_anim)
			death_anim.play("default");
			death_anim.global_position = global_position;
			
			particle_explosion.get_parent().remove_child(particle_explosion);
			get_parent().add_child(particle_explosion);
			particle_explosion.global_position = global_position;
			particle_explosion.trigger();
			
			$Vacuumable.resistance = 1000;
			$Vacuumable.can_be_eaten = false;
			remove_child($CollisionShape2D)
			await death_anim.animation_finished;
			queue_free();
func set_health_multiplier(health_multiplier):
	health_bar.max *= health_multiplier;
	health_bar.set_value(health_bar.max);
