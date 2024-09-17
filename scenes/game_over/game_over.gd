extends CanvasLayer
@onready var line_edit:LineEdit = $ScoreSubmit/LineEdit
@onready var submit_score_btn = $ScoreSubmit/Submit
@onready var score_saving_spinner = $ScoreSubmit/ScoreSavingSpinner
@onready var score_saved_txt = $ScoreSubmit/ScoreSaved
@onready var new_high_score = $ScoreSubmit/NewHighScore
@onready var reset_btn = $ResetBtn
@onready var leaderboards_btn = $LeaderboardsBtn

@export var score_label:Label;
@export var high_score_label:Label;

var high_score:int;
var score:int;
var can_exit_screen:bool = true;
# Called when the node enters the scene tree for the first time.
func _ready():
	set_score(Score.current_score);
	set_high_score(Score.high_score);

func set_score(score):
	score_label.text = str(score) + " days"
	self.score = score;

func set_high_score(high_score):
	# this is the old high score, so if we beat it with our current score we shld reflect that
	self.high_score = high_score;
	high_score_label.text = str(self.high_score) + " days";
	check_if_shld_submit(); 

func check_if_shld_submit():
	if score > high_score:
		reset_btn.disabled = true;
		leaderboards_btn.disabled = true;
		high_score = score;
		new_high_score.visible = true;
		# we want to ask the player to submit their score
		# and they almost certainly don't want to leave this screen
		# without saving their high score
		can_exit_screen = false;

		var config = ConfigFile.new()
		# Load data from a file.
		var err = config.load("user://name.cfg")
		# If the file didn't load, ignore it.
		if err == OK:
			var player_name = config.get_value("player", "player_name")
			line_edit.text = player_name;

		$ScoreSubmit.visible = true
	else:
		$ScoreSubmit.visible = false;

func _on_submit_pressed():
	var config = ConfigFile.new()
	config.set_value("player", "player_name", line_edit.text)
	config.save("user://name.cfg")
	
	score_saving_spinner.visible = true;
	var sw_result:Dictionary = await SilentWolf.Scores.save_score(line_edit.text, high_score).sw_save_score_complete;
	score_saving_spinner.visible = false;
	score_saved_txt.visible = true;
	
	reset_btn.disabled = false;
	leaderboards_btn.disabled = false;


func _on_reset_btn_pressed():
	Events.change_scene.emit(MainScene.State.GAME);


func _on_leaderboards_btn_pressed():
	Events.change_scene.emit(MainScene.State.LEADERBOARD);
