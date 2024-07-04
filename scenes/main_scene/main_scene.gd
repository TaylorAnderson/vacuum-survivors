extends Node2D

enum State {
	TITLE,
	GAME,
	GAME_OVER,
	LEADERBOARD,
}
@export var game_scene_file:PackedScene;
@onready var title_scene = $Title
@onready var game_scene = $Game
@onready var game_over_scene = $GameOver
@onready var leaderboard_scene = $Leaderboard

var state:State;
var state_scenes = {};
@onready var intro_anim = $Title/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	SilentWolf.configure({
		"api_key": "oOU7kLCBd12H9AKSeNDUoaXVRGOlF9RW2bnCleWc",
		"game_id": "VacuumSurvivors",
		"log_level": 0
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/main_scene/main_scene.tscn"
	})
	state_scenes[State.TITLE] = title_scene;
	state_scenes[State.GAME] = game_scene;
	state_scenes[State.GAME_OVER] = game_over_scene;
	state_scenes[State.LEADERBOARD] = leaderboard_scene;
	change_state(State.TITLE);
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == State.TITLE or state == State.GAME_OVER:
		if state_scenes[state].can_exit_screen:
			if Input.is_action_just_pressed("advance_screen"):
				change_state(State.GAME)
			if Input.is_action_just_pressed("go_to_leaderboard"):
				change_state(State.LEADERBOARD);



func change_state(new_state:State):
	var old_state = state;
	state = new_state;
	
	state_scenes[old_state].visible = false;
	state_scenes[new_state].visible = true;
	
	
	if state_scenes[new_state].has_method("on_enter"):
		state_scenes[new_state].on_enter();

	if new_state == State.TITLE:
		get_tree().paused = true;
	if new_state == State.GAME_OVER:
		get_tree().paused = true;
	if new_state == State.GAME:
		print("unpausing");
		get_tree().paused = false;
		game_scene.queue_free();
		game_scene = game_scene_file.instantiate();
		game_scene.player_died.connect(_on_game_player_died);
		state_scenes[State.GAME] = game_scene;
		add_child(game_scene);
		Upgrades.reset();
		

		$Game/Player.visible = true;
	if new_state == State.LEADERBOARD:
		leaderboard_scene.set_process(true);
	
func _on_game_player_died():
	await get_tree().create_timer(2).timeout
	get_tree().paused = true;
	change_state(State.GAME_OVER);


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_leaderboard_leaderboard_closed():
	change_state(State.TITLE);
