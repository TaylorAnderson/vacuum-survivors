extends EnemyMovement

enum State {
	CHASING,
	CHARGING,
	DASHING
}
@onready var ray_cast = $ShapeCast2D as ShapeCast2D
@export var collider:CollisionShape2D
@export var charge_time:float = 1;
var charge_timer = 0;

@export var dash_time:float = 1;
var dash_timer:float = 0;
@export var distance_before_charge:float = 32;
@export var dash_speed:float = 5;
@export_flags_2d_physics var dash_layer:int
var parent_original_mask:int;
var dash_direction = Vector2.ZERO;
var state:State = State.CHASING;

var raycast_length:float = 0;

var parent_original_sprite_scale;

var charge_cooldown_time = 1;
var charge_cooldown_timer = 0;

func _ready():
	raycast_length = ray_cast.target_position.length();
	parent_original_mask = parent.collision_mask;
	await get_tree().process_frame
	
func do_movement(delta):
	if state == State.CHASING:
		if parent_original_sprite_scale:
			parent.sprite.scale = parent_original_sprite_scale
		else: 
			parent_original_sprite_scale = parent.sprite.scale;
		super.do_movement(delta);
		parent.collision_mask = parent_original_mask;
		charge_cooldown_timer += delta;
		if charge_cooldown_timer > charge_cooldown_time:
			if parent.global_position.distance_to(player.global_position) < distance_before_charge:
				state = State.CHARGING;
		

	if state == State.CHARGING:
		parent.velocity = Vector2.ZERO;
		charge_timer += delta;
		parent.sprite.scale += Vector2.ONE * 0.02;
		if charge_timer > charge_time:
			charge_timer = 0;
			state = State.DASHING
			dash_direction = Vector2.RIGHT.rotated(parent.sprite.rotation + PI/2);
	if state == State.DASHING:
		if parent_original_sprite_scale:
			parent.sprite.scale = parent_original_sprite_scale
		else: 
			parent_original_sprite_scale = parent.sprite.scale;
		parent.collision_mask = dash_layer;
		ray_cast.target_position = dash_direction * (raycast_length * 2);
		dash_timer += delta;
		parent.velocity = dash_direction * dash_speed;
		parent.sprite.rotation = dash_direction.angle() - PI/2;
		ray_cast.force_shapecast_update();
		for i in ray_cast.get_collision_count():
			var col = ray_cast.get_collider(i);
			var normal = ray_cast.get_collision_normal(i);
			if col:
				print("COLLIDING");
				dash_direction = normal.reflect(dash_direction);
				break;
		if dash_timer > dash_time:
			dash_timer = 0;
			state = State.CHASING;
	
			
	do_slime_effect();
	parent.move_and_slide();
