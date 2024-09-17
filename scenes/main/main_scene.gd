extends Node2D
class_name MainScene
enum State {
	TITLE,
	GAME,
	END_DAY,
	GAME_OVER,
	LEADERBOARD,
	SHOP
}

@export var game_scene_file:PackedScene;
@export var title_scene_file:PackedScene;
@export var eod_scene_file:PackedScene;
@export var game_over_scene_file:PackedScene;
@export var shop_scene_file:PackedScene;
@export var leaderboard_scene_file:PackedScene;

@export var start_scene:State;

var eod_data;

var state:State;
var current_scene;
@onready var music_player = $MusicPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.money = 100;
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	SilentWolf.configure({
		"api_key": "oOU7kLCBd12H9AKSeNDUoaXVRGOlF9RW2bnCleWc",
		"game_id": "VacuumSurvivors",
		"log_level": 0
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/main_scene/main_scene.tscn"
	})
	
	
	change_state(start_scene);
	
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load("user://name.cfg")
	
	if err == OK:
		var player_name = config.get_value("player", "player_name")
		
		if player_name:
			var sw_result:Dictionary = await SilentWolf.Scores.get_top_score_by_player(player_name).sw_top_player_score_complete 
			if sw_result.has("top_score"):
				Score.high_score = sw_result.top_score.score;
				print("Got top player score: " + str(sw_result.top_score))
	Events.change_scene.connect(change_state);

func change_state(new_state:State, data = null):
	var old_state = state;
	state = new_state;
	if current_scene and is_instance_valid(current_scene): 
		current_scene.queue_free();
	if new_state == State.TITLE:
		current_scene = title_scene_file.instantiate();
	if new_state == State.GAME_OVER:
		Upgrades.reset();
		current_scene = game_over_scene_file.instantiate();
	if new_state == State.GAME:
		current_scene = game_scene_file.instantiate()
		current_scene.player_died.connect(_on_game_player_died);

	if new_state == State.END_DAY:
		current_scene = eod_scene_file.instantiate();
	if new_state == State.SHOP:
		current_scene = shop_scene_file.instantiate();
	if new_state == State.LEADERBOARD:
		current_scene = leaderboard_scene_file.instantiate();
	add_child(current_scene);
	if current_scene.has_method("on_enter"):
		current_scene.on_enter();
		
	if new_state == State.END_DAY:
		current_scene.init(data);
	music_player.change_music(new_state);
func _on_game_player_died():
	await get_tree().create_timer(2).timeout
	change_state(State.GAME_OVER);

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
