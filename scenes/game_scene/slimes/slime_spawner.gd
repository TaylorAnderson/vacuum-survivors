extends Node2D
@onready var spawn_timer:Timer = $SpawnTimer

@export var spawn_interval:float = 3;
@export var initial_spawn = 20;
@export var slime_scenes:Array[PackedScene];
@export var weights:Array[float]
## as in, the time in seconds before we spawn this slime;
@export var wait_times:Array[float]
@export var player:Node2D;
@export var spawn_decrease = 0.05;
var health_multiplier = 1.0;
@export var health_multiplier_increase = 0.1; 
@export var min_spawn_distance_from_player = 100;
var spawns:Array[Marker2D]
var unused_spawns:Array[Marker2D]

var spawn_refresh_rate = 5;
var spawn_refresh_rate_timer = 0;
var done_initial_spawn = false;
var time_in_level = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_in_level += delta;
	# doing it here so we don't try to spawn enemies before the game is unpaused
	if not done_initial_spawn:
		done_initial_spawn = true;
		$SpawnTimer.start($SpawnTimer.wait_time);
		for row in $EnemySpawns.get_children():
			for spawn in row.get_children():
				spawns.append(spawn);
		unused_spawns = spawns;
		for i in initial_spawn:
			call_deferred("spawn_slime");
	spawn_refresh_rate_timer += delta;
	if spawn_refresh_rate_timer > spawn_refresh_rate:
		
		# i suspect this is just as performant as calling .duplicate()
		# but just in case
		unused_spawns = [];
		for spawn in spawns: unused_spawns.append(spawn);
		
		spawn_refresh_rate_timer = 0;

func spawn_slime():
	var potential_slimes = [];
	var potential_weights = [];
	for i in wait_times.size():
		if time_in_level >= wait_times[i]:
			potential_slimes.append(slime_scenes[i]);
			potential_weights.append(weights[i]);
	var new_slime = choice(potential_slimes, potential_weights).instantiate();
	new_slime.player = player;
	
	var potential_spawns = [];
	for spawn in unused_spawns:
		if spawn.global_position.distance_to(player.global_position) > min_spawn_distance_from_player:
			potential_spawns.append(spawn);
	if potential_spawns.size() <= 0: return;
	var slime_spawn = potential_spawns.pick_random()
	unused_spawns.erase(slime_spawn);
	new_slime.global_position = slime_spawn.global_position
	await get_tree().create_timer(0.5).timeout
	new_slime.call_deferred("set_health_multiplier", health_multiplier);
	get_parent().add_child(new_slime);
func _on_spawn_timer_timeout():
	spawn_slime()
	spawn_interval -= spawn_decrease;
	health_multiplier += health_multiplier_increase
	spawn_timer.start(spawn_interval)
func choice(array: Array, weights: Array):
	assert(array.size() == weights.size())

	var sum:float = 0.0
	for val in weights:
		sum += val

	var normalizedWeights = []

	for val in weights:
		normalizedWeights.append(val / sum)

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rnd = rng.randf()

	var i = 0
	var summer:float = 0.0

	for val in normalizedWeights:
		summer += val
		if summer >= rnd:
			return array[i]
		i += 1
